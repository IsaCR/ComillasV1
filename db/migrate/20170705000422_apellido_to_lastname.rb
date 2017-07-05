class ApellidoToLastname < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :apellido, :lastname
  end
end
