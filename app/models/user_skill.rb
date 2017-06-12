class UserSkill < ApplicationRecord
	belongs_to :users
	belongs_to :skills
end
