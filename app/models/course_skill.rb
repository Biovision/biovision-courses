class CourseSkill < ApplicationRecord
  PRIORITY_RANGE = (1..100)
  BODY_LIMIT     = 200

  belongs_to :course

  after_initialize :set_next_priority
  before_validation :normalize_priority

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :ordered_by_priority, -> { order 'priority asc, body asc' }
  scope :visible, -> { where(visible: true) }
  scope :siblings, ->(course_id) { where(course_id: course_id) }

  def self.page_for_administration
    ordered_by_priority
  end

  def self.entity_parameters
    %i(priority body)
  end

  def self.creation_parameters
    entity_parameters + %i(course_id)
  end

  def locked?
    course.locked?
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
