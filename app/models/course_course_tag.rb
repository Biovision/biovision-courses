class CourseCourseTag < ApplicationRecord
  belongs_to :course
  belongs_to :course_tag, counter_cache: :courses_count

  after_create :update_course_tags_cache
  after_destroy :update_course_tags_cache

  validates_uniqueness_of :course_tag_id, scope: [:course_id]

  private

  def update_course_tags_cache
    course.update tags_cache: course.course_tags.ordered_by_name.map(&:name)
  end
end
