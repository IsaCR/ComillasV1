class ChangeProjectsColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :projects, :is_active, :in_progress
    add_column :projects, :student_id, :integer
  end
end
