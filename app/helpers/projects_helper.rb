module ProjectsHelper
  def project_skills id
    Project.find(id).skills
  end
end
