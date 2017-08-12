class Users::RegistrationsController < Devise::RegistrationsController

  def signup_as
    if params[:singup_as] == 'student'
      type_of_user = 'student'
    end
    redirect_to  action: 'new', type_of_user: type_of_user
  end
end
