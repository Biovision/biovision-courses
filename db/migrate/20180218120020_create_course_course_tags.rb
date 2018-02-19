class CreateCourseCourseTags < ActiveRecord::Migration[5.1]
  def up
    unless CourseCourseTag.table_exists?
      create_table :course_course_tags do |t|
        t.timestamps
        t.references :course, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :course_tag, foreign_key: { on_update: :cascade, on_delete: :cascade }
      end
    end
  end

  def down
    if CourseCourseTag.table_exists?
      drop_table :course_course_tags
    end
  end
end
