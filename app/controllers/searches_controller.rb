class SearchesController < ApplicationController
  # GET /searches/new
  def new
  end

  # POST /searches
  def create
    students = User.where(is_student: true)
    students = students.where('name ILIKE ?', "%#{params[:name]}%") if params[:name].present?
    students = students.where('lastname ILIKE ?', "%#{params[:lastname]}%") if params[:lastname].present?
    students = students.where('email ILIKE ?', "%#{params[:email]}%") if params[:email].present?
    @result = order_students students
    render 'index'
  end

  private

    def order_students students
      order_students = []
      return students if params[:skill][:ids] == [""]
      students.each do |student|
        next if student.skills.count <= 0
        user_skills = student.skills.map(&:id)
        matching_skills = (params[:skill][:ids] & user_skills.map(&:to_s)).count
        order_students << {
          matching_porcentage: matching_skills * 100 / params[:skill][:ids].count,
          user: student
        }
      end
      order_students.sort_by! { |k| k[:matching_porcentage] * -1}
      order_students.map { |k| k[:user] }
    end
end
