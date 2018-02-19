class CourseCourseTag < ApplicationRecord
  after_create :update_course_tags_cache
  after_destroy :update_course_tags_cache

  belongs_to :course
  belongs_to :course_tag, counter_cache: :courses_count

  private

  def update_course_tags_cache
    course.update tags_cache: course.course_tags.ordered_by_name.map(&:name)
  end
end
