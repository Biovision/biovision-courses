class AddVisibleToTeachers < ActiveRecord::Migration[5.2]
  def change
    add_column :teachers, :visible, :boolean, default: true, null: false
  end
end
