class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
	  devise_parameter_sanitizer.permit(:sign_in) do |user_params|
	    user_params.permit(:username, :email)
	  end

	  devise_parameter_sanitizer.permit(:sign_up) do |user_params|
	    user_params.permit(:username,
												 :email,
												 :name,
												 :lastname,
												 :is_admin,
												 :is_student,
												 :password,
												 :avatar,
												 skill_ids: []
			)
	  end

	  devise_parameter_sanitizer.permit(:account_update) do |user_params|
	    user_params.permit(:username,
												 :email,
												 :name,
												 :lastname,
												 :is_admin,
												 :is_student,
												 :current_password,
												 :avatar,
												 skill_ids: [],
			)
	  end
	end

	def after_sign_in_path_for(resource)
		if current_user.is_student?
			projects_path
		else
			students_path
		end
	end
end
