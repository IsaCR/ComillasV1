module SearchesHelper

  def get_skills_for_search
    Skill.all.each(&:description);
  end
end
