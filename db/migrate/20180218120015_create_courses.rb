class CreateCourses < ActiveRecord::Migration[5.1]
  def up
    unless Course.table_exists?
      create_table :courses do |t|
        t.timestamps
        t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :course_category, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
        t.inet :ip
        t.integer :priority, limit: 2, default: 1, null: false
        t.integer :users_count, default: 0, null: false
        t.boolean :visible, default: true, null: false
        t.boolean :highlight, default: false, null: false
        t.boolean :online, default: true, null: false
        t.boolean :deleted, default: false, null: false
        t.boolean :locked, default: false, null: false
        t.integer :price
        t.integer :special_price
        t.date :special_price_end
        t.string :title, null: false
        t.string :subtitle
        t.string :slug, null: false
        t.string :meta_title
        t.string :meta_description
        t.string :meta_keywords
        t.string :duration
        t.string :image
        t.string :image_alt_text
        t.text :lead
        t.text :description
        t.string :tags_cache, array: true, default: [], null: false
        t.json :metadata
      end
    end
  end

  def down
    if Course.table_exists?
      drop_table :courses
    end
  end
end
