class UsersController < ApplicationController
  def get_students
    if current_user.is_student?
      redirect_to root_path
    else
      @users = User.where(is_student: true).paginate(page: params[:page], per_page: 9)
      render :index
    end
  end

  def show
    @project = Project.find(params[:p_id]) if params[:p_id]
    @user = User.find(params[:u_id]) if params[:u_id]
  end
end