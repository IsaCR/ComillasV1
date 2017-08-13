class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :project
  ratyrate_rateable 'accuracy', 'quality_of_coding', 'communication', 'timing'
end
