class CreateCourseUsers < ActiveRecord::Migration[5.1]
  def up
    unless CourseUser.table_exists?
      create_table :course_users do |t|
        t.timestamps
        t.references :course, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
        t.integer :price, default: 0, null: false
        t.boolean :finished, default: false, null: false
      end
    end
  end

  def down
    if CourseUser.table_exists?
      drop_table :course_users
    end
  end
end
