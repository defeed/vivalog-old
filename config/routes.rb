Rails.application.routes.draw do
  devise_for :users
  resources :projects
  resources :entries, only: [:new, :create, :destroy]

  root 'projects#index'
end
