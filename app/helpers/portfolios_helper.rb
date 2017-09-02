module PortfoliosHelper
  def get_portfolio_skills(project)
    skills = []
    project.skills.each do |skill|
      skills << skill.description
    end
    skills.join(', ')
  end
end
