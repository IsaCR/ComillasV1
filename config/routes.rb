Rails.application.routes.draw do
  root 'projects#index'
  resources :skills
  resources :portfolios
  resources :projects
  get 'students' => 'users#get_students'
  devise_for :users
  devise_scope :user do
    get 'users/sign_out' => "devise/sessions#destroy"
    get 'users' => "projects#index"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
