Rails.application.routes.draw do
  root 'projects#index'
  resources :skills
  resources :portfolios
  resources :projects
  get 'students' => 'users#get_students'
  devise_for :users
  devise_scope :user do
    get 'users/sign_out' => 'devise/sessions#destroy'
    get 'users' => 'projects#index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # mailbox folder routes
  get 'mailbox/inbox' => 'mailbox#inbox', as: :mailbox_inbox
  get 'mailbox/sent' => 'mailbox#sent', as: :mailbox_sent
  get 'mailbox/trash' => 'mailbox#trash', as: :mailbox_trash

  # conversations
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  get 'apply' => 'conversations#apply'
end
