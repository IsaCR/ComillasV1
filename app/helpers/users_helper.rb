module UsersHelper
  def get_skills(user)
    skills = []
    user.skills.each do |skill|
      skills << skill.description
    end
    skills.join(', ')
  end
end