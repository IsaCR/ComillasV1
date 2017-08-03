class UsersController < ApplicationController
  def get_students
    if current_user.is_student?
      redirect_to root_path
    else
      @users = User.all
      render :index
    end
  end
end