module ProjectsHelper
  def project_skills project
    skills = []
    project.skills.each do |skill|
      skills << skill.description
    end
    skills.join(', ')
  end

  def interested_students student_ids
    User.where(id: student_ids)
  end

  def can_apply?
    can_apply = @project.interested_students ? @project.interested_students.exclude?(current_user.id) : true
    current_user.is_student? && can_apply
  end

  def can_conclude?
    @project.in_progress &&
      @project.student_id &&
      @project.user == current_user
  end

  def can_edit?
    @project.in_progress.nil? &&
      @project.user == current_user
  end
end
