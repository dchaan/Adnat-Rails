Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'logout' => 'sessions#destroy', :as => "logout"
  get 'login' => 'sessions#new', :as => "login"
  get 'signup' => 'users#new', :as => "signup"
  get 'welcome' => 'sessions#welcome', :as => "welcome"
  get 'overview' => 'sessions#overview', :as => "overview"
  put 'leave/:id' => 'users#leave_org', :as => "leave_org"
  put 'join/:id' => 'users#join_org', :as => "join_org"

  root :to => "sessions#overview"

  resources :users, only: [:new, :create, :edit, :update, :join_org, :leave_org]
  resources :sessions, only: [:new, :create, :destoy, :welcome, :overview]
  resources :organizations, only: [:create, :edit, :update, :destroy]
  resources :shifts, only: [:index, :create, :edit, :update, :destroy]
end
