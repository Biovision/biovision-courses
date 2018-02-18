class CreateCourseTags < ActiveRecord::Migration[5.1]
  def up
    unless CourseTag.table_exists?
      create_table :course_tags do |t|
        t.timestamps
        t.boolean :visible, default: true, null: false
        t.integer :courses_count, default: 0, null: false
        t.string :name, null: false
        t.string :slug, null: false
        t.string :image
      end
    end
  end

  def down
    if CourseTag.table_exists?
      drop_table :course_tags
    end
  end
end
