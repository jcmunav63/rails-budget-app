Rails.application.routes.draw do
  # get 'splash/index'
  # get 'categories/index'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root 'splash#index'
  # root to: "categories#index"

  resources :users, only: [:index] do
    resources :categories, only: [:index, :show, :new, :create] do # , :destroy, :show
      resources :category_expenses, only: [:index] do # , :new, :create, :destroy
      end
    end
    resources :expenses, only: [:index] do
    end
  end
end
