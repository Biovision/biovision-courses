class CourseCategory < ApplicationRecord
  include Toggleable

  PRIORITY_RANGE    = (1..500)
  NAME_LIMIT        = 50
  SLUG_LIMIT        = 50
  SLUG_PATTERN      = /\A[a-z][-0-9a-z]*[0-9a-z]\z/i
  SLUG_PATTERN_HTML = '^[a-zA-Z][-0-9a-zA-Z]*[0-9a-zA-Z]$'

  toggleable :visible

  mount_uploader :image, CourseImageUploader

  belongs_to :parent, class_name: CourseCategory.to_s, optional: true, touch: true
  has_many :child_categories, class_name: CourseCategory.to_s, foreign_key: :parent_id, dependent: :destroy
  has_many :courses, dependent: :destroy

  after_initialize :set_next_priority
  before_validation { self.slug = Canonizer.transliterate(name.to_s) if slug.blank? }
  before_validation { self.slug = slug.to_s.downcase }
  before_validation :generate_long_slug
  before_validation :normalize_priority
  before_save { self.children_cache.uniq! }
  after_create :cache_parents!
  after_save { parent.cache_children! unless parent.nil? }

  validates_presence_of :name, :slug
  validates_uniqueness_of :name, scope: [:parent_id]
  validates_uniqueness_of :slug, scope: [:parent_id]
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_format_of :slug, with: SLUG_PATTERN

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }
  scope :visible, -> { where(visible: true, deleted: false) }
  scope :for_tree, ->(parent_id = nil) { siblings(parent_id).ordered_by_priority }
  scope :siblings, ->(parent_id) { where(parent_id: parent_id) }

  def self.entity_parameters
    %i(image name slug priority visible)
  end

  def self.creation_parameters
    entity_parameters + %i(parent_id)
  end

  def full_title
    (parents.map { |parent| parent.name } + [name]).join ' / '
  end

  def depth
    parent_ids.count
  end

  def parent_ids
    parents_cache.split(',').compact
  end

  # @return [Array<Integer>]
  def branch_ids
    parents_cache.split(',').map(&:to_i).reject { |i| i < 1 }.uniq + [id]
  end

  # @return [Array<Integer>]
  def subbranch_ids
    [id] + children_cache
  end

  def image_alt_text
    name
  end

  def parents
    return [] if parents_cache.blank?
    CourseCategory.where(id: parent_ids).order('id asc')
  end

  def cache_parents!
    return if parent.nil?
    self.parents_cache = "#{parent.parents_cache},#{parent_id}".gsub(/\A,/, '')
    save!
  end

  def cache_children!
    child_categories.order('id asc').each do |child|
      self.children_cache += [child.id] + child.children_cache
    end
    save!
  end

  def can_be_deleted?
    !locked? && child_categories.count < 1
  end

  # @param [Course] course
  def course?(course)
    course.course_category == self
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { parent_id: parent_id, priority: new_priority }
    adjacent     = self.class.find_by(criteria)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    self.update(priority: new_priority)

    self.class.for_tree(parent_id).map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.siblings(parent_id).maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end

  def generate_long_slug
    if parent.nil?
      self.long_slug = slug
    else
      self.long_slug = "#{parent.long_slug}_#{slug}"
    end
  end
end
