class UsersController < ApplicationController
  def get_students
    if current_user.is_student?
      redirect_to root_path
    else
      @users = User.where(is_student: true)
      render :index
    end
  end

  def show
    @project = Project.find(params[:p_id])
    @user = User.find(params[:u_id])
  end
end