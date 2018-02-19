class Course < ApplicationRecord
  include HasOwner
  include Toggleable

  PER_PAGE = 24

  DESCRIPTION_LIMIT = 50000
  DURATION_LIMIT    = 50
  LEAD_LIMIT        = 1000
  META_LIMIT        = 255
  PRIORITY_RANGE    = (1..999)
  SLUG_LIMIT        = 250
  SLUG_PATTERN      = /\A[a-z][-0-9a-z]*[0-9a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-0-9a-zA-Z]*[0-9a-zA-Z]$'
  TITLE_LIMIT       = 250

  toggleable :visible, :highlight, :online

  mount_uploader :image, CourseImageUploader

  belongs_to :course_category, optional: true, counter_cache: true
  belongs_to :user, optional: true
  belongs_to :agent, optional: true
  has_many :course_course_tags, dependent: :destroy
  has_many :course_tags, through: :course_course_tags

  after_initialize :set_next_priority
  before_validation { self.slug = Canonizer.transliterate(title.to_s) if slug.blank? }
  before_validation { self.slug = slug.to_s.downcase }
  before_validation :normalize_priority

  validates_presence_of :title, :slug
  validates_uniqueness_of :title
  validates_uniqueness_of :slug
  validates_length_of :title, maximum: TITLE_LIMIT
  validates_length_of :subtitle, maximum: TITLE_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :meta_title, maximum: META_LIMIT
  validates_length_of :meta_keywords, maximum: META_LIMIT
  validates_length_of :meta_description, maximum: META_LIMIT
  validates_length_of :lead, maximum: LEAD_LIMIT
  validates_length_of :description, maximum: DESCRIPTION_LIMIT
  validates_length_of :duration, maximum: DURATION_LIMIT
  validates_numericality_of :price, greater_than_or_equal_to: 0, allow_blank: true
  validates_numericality_of :special_price, greater_than_or_equal_to: 0, allow_blank: true

  scope :ordered_by_priority, -> { order 'priority asc, title asc' }
  scope :visible, -> { where(visible: true, deleted: false) }
  scope :for_tree, ->(course_category_id = nil) { siblings(course_category_id).ordered_by_priority }
  scope :siblings, ->(course_category_id) { where(course_category_id: course_category_id) }

  def self.entity_parameters
    texts      = %i(title subtitle slug lead description duration)
    decoration = %i(price special_price special_price_end image image_alt_text)
    meta_texts = %i(meta_title meta_keywords meta_description metadata)
    meta_data  = %i(course_category_id priority visible highlight online)

    texts + decoration + meta_texts + meta_data
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { course_category_id: course_category_id, priority: new_priority }
    adjacent     = self.class.find_by(criteria)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    self.update(priority: new_priority)

    self.class.for_tree(course_category_id).map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.siblings(course_category_id).maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end
end
