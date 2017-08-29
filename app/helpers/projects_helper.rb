module ProjectsHelper
  def project_skills id
    Project.find(id).skills
  end

  def interested_students student_ids
    student_ids.map do |id|
      User.find(id)
    end
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
