class AddProjectIdToPortfolio < ActiveRecord::Migration[5.0]
  def change
    add_column :portfolios, :project_id, :integer
  end
end
