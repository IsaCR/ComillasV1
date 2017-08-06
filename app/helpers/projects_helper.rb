module ProjectsHelper
  def project_skills id
    Project.find(id).skills
  end

  def interested_students student_ids
    student_ids.map do |id|
      User.find(id)
    end
  end
end
