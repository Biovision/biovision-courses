class CreateTeachers < ActiveRecord::Migration[5.1]
  def up
    unless Teacher.table_exists?
      create_table :teachers do |t|
        t.timestamps
        t.integer :courses_count, default: 0, null: false
        t.string :name, null: false
        t.string :surname, null: false
        t.string :image
        t.string :title
        t.text :description
      end
    end
  end

  def down
    if Teacher.table_exists?
      drop_table :teachers
    end
  end
end
