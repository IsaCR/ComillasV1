class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, email: true

  has_many :projects
  has_many :portfolios

  has_and_belongs_to_many :skills

  has_attached_file :avatar,
                    styles: { thumb: "30x30>",
                              medium: "300x300>" },
                    default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar,
                                    size: { :in => 0..10.megabytes },
                                    content_type: ["image/jpeg", "image/gif", "image/png","image/jpg"]

  acts_as_messageable

  ratyrate_rateable 'accuracy', 'quality_of_coding', 'communication', 'timing'

  ratyrate_rater

  def mailboxer_name
    self.name
  end

  def mailboxer_email(object)
    self.email
  end
end
