class ChangeDataTypeForDescription < ActiveRecord::Migration[5.0]
  def change
    change_table :projects do |t|
      t.change :description, :text
    end

    change_table :portfolios do |t|
      t.change :description, :text
    end
  end
end
