Rails.application.routes.draw do
  resources :projects do
    resources :entries, shallow: true
  end

  root 'projects#index'
end
