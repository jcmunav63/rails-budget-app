Rails.application.routes.draw do
  # get 'categories/index'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root to: "categories#index"

  # Defines the root path route ("/")
  # root "categories#index"
end
