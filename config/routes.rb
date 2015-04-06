Rails.application.routes.draw do
  resources :projects
  resources :entries, only: [:new, :create, :destroy]

  root 'projects#index'
end
