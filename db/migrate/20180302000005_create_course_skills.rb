class CreateCourseSkills < ActiveRecord::Migration[5.1]
  def change
    unless CourseSkill.table_exists?
      create_table :course_skills do |t|
        t.timestamps
        t.references :course, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :body, null: false
      end
    end
  end

  def down
    if CourseSkill.table_exists?
      drop_table :course_skills
    end
  end
end
