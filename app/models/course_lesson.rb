class CourseLesson < ApplicationRecord
  PRIORITY_RANGE = (1..100)
  BODY_LIMIT     = 65535
  NAME_LIMIT     = 250
  DURATION_LIMIT = 30
  URL_LIMIT      = 250
  LEAD_LIMIT     = 1000

  mount_uploader :image, CourseImageUploader
  mount_uploader :video_file, LessonVideoUploader
  mount_uploader :preview_file, LessonPreviewUploader

  belongs_to :course

  after_initialize { self.uuid = SecureRandom.uuid if uuid.nil? }
  after_initialize :set_next_priority
  before_validation :normalize_priority

  validates_presence_of :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :duration, maximum: DURATION_LIMIT
  validates_length_of :video_url, maximum: URL_LIMIT
  validates_length_of :body, maximum: BODY_LIMIT

  scope :ordered_by_priority, -> { order 'priority asc, name asc' }
  scope :siblings, ->(course_id) { where(course_id: course_id) }

  def self.page_for_administration
    ordered_by_priority
  end

  def self.entity_parameters
    %i(
      priority duration name image
      body video_url video_file lead preview_url preview_file
    )
  end

  def self.creation_parameters
    entity_parameters + %i(course_id)
  end

  def image_alt_text
    "#{course.title} — #{name}"
  end

  def title
    name
  end

  def locked?
    course.locked?
  end

  # @param [User] user
  def editable_by?(user)
    course.editable_by?(user)
  end

  def preview?
    has_video = !preview_file.blank? || !preview_url.blank?

    has_video || !lead.blank?
  end

  # @param [Integer] delta
  def change_priority(delta)
    new_priority = priority + delta
    criteria     = { course_id: course_id, priority: new_priority }
    adjacent     = self.class.find_by(criteria)
    if adjacent.is_a?(self.class) && (adjacent.id != id)
      adjacent.update!(priority: priority)
    end
    self.update(priority: new_priority)

    self.class.siblings(course_id).ordered_by_priority.map { |e| [e.id, e.priority] }.to_h
  end

  private

  def set_next_priority
    if id.nil? && priority == 1
      self.priority = self.class.siblings(course_id).maximum(:priority).to_i + 1
    end
  end

  def normalize_priority
    self.priority = PRIORITY_RANGE.first if priority < PRIORITY_RANGE.first
    self.priority = PRIORITY_RANGE.last if priority > PRIORITY_RANGE.last
  end
end
