class Project < ApplicationRecord
	belongs_to :user
	has_and_belongs_to_many :skills

	serialize :interested_students

	has_attached_file :image,
										styles: { thumb: "300x300>",
															medium: "700x400>" },
										default_url: "/images/:style/missing.png"
	validates_attachment_content_type :image,
																		size: { :in => 0..10.megabytes },
																		content_type: ["image/jpeg", "image/gif", "image/png","image/jpg"]
end
