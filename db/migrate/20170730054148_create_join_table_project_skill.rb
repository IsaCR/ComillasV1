class CreateJoinTableProjectSkill < ActiveRecord::Migration[5.0]
  def change
    create_join_table :projects, :skills do |t|
      t.index [:project_id, :skill_id]
    end
  end
end
