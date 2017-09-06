class Users::RegistrationsController < Devise::RegistrationsController

  def signup_as
    if params[:singup_as] == 'student'
      $type_of_user = 'student'
  	else
		$type_of_user = 'company'
    end
    redirect_to  action: 'new'
  end
end
