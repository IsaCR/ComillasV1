module UsersHelper
  def get_skills(user)
    skills = []
    user.skills.each do |skill|
      skills << skill.description
    end
    skills.join(', ')
  end

  def can_rate? student_id
    current_user.projects.where(student_id: student_id, in_progress: 0).empty?
  end

  def show_accept_students?
    @project.present? &&
      !current_user.is_student? &&
      @project.in_progress.nil?
  end
end