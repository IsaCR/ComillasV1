class SearchesController < ApplicationController
  # GET /searches/new
  def new
  end

  # POST /searches
  # POST /searches.json
  def create
    students = order_students
    if params[:name].present?
      students.delete_if do |student|
        student[:user].name.downcase().exclude? params[:name].downcase()
      end
    end
    if params[:lastname].present?
      students.delete_if do |student|
        student[:user].lastname.downcase().exclude? params[:lastname].downcase()
      end
    end
    if params[:email].present?
      students.delete_if do |student|
        student[:user].email.downcase().exclude? params[:email].downcase()
      end
    end
    students.sort_by! { |k| k[:matching_porcentage] * -1}
    @result = students.map { |k| k[:user] }
    render 'index'
  end

  private

    def order_students
      order_students = []
      return order_students if params[:skill][:ids] == [""]
      students = User.where(is_student: true)
      students.each do |student|
        next if student.skills.count <= 0
        user_skills = student.skills.map(&:id)
        matching_skills = (params[:skill][:ids] & user_skills.map(&:to_s)).count
        order_students << {
          matching_porcentage: matching_skills * 100 / params[:skill][:ids].count,
          user: student
        }
      end
      order_students
    end
end
