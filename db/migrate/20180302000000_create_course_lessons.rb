class CreateCourseLessons < ActiveRecord::Migration[5.1]
  def up
    unless CourseLesson.table_exists?
      create_table :course_lessons do |t|
        t.timestamps
        t.references :course, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :uuid, null: false
        t.string :name, null: false
        t.string :duration
        t.string :video_url
        t.string :video_file
        t.string :image
        t.text :body
      end
    end
  end

  def down
    if CourseLesson.table_exists?
      drop_table :course_lessons
    end
  end
end
