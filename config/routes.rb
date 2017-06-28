Rails.application.routes.draw do
  root 'projects#index'
  resources :user_skills
  resources :skills
  resources :portfolios
  resources :projects
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
