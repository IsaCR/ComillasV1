class AddInterestedStudentsToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :interested_students, :text
  end
end
