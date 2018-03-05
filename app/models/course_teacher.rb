class CourseTeacher < ApplicationRecord
  belongs_to :course
  belongs_to :teacher

  validates_uniqueness_of :teacher_id, scope: [:course_id]
end
