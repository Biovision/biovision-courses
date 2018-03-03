class CreateCourseTeachers < ActiveRecord::Migration[5.1]
  def up
    unless CourseTeacher.table_exists?
      create_table :course_teachers do |t|
        t.timestamps
        t.references :course, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :teacher, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end
    end
  end

  def down
    if CourseTeacher.table_exists?
      drop_table :course_teachers
    end
  end
end
