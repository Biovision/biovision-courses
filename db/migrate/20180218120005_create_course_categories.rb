class CreateCourseCategories < ActiveRecord::Migration[5.1]
  def up
    unless CourseCategory.table_exists?
      create_table :course_categories do |t|
        t.timestamps
        t.integer :parent_id
        t.boolean :visible, default: true, null: false
        t.boolean :deleted, default: false, null: false
        t.integer :priority, limit: 2, default: 1, null: false
        t.integer :courses_count, default: 0, null: false
        t.string :name, null: false
        t.string :slug, null: false
        t.string :long_slug, null: false
        t.string :image
        t.string :parents_cache, default: '', null: false
        t.integer :children_cache, array: true, default: [], null: false
      end

      add_foreign_key :course_categories, :course_categories, column: :parent_id, on_update: :cascade, on_delete: :cascade
    end
  end

  def down
    if CourseCategory.table_exists?
      drop_table :course_categories
    end
  end
end
