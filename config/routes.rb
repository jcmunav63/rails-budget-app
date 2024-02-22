Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  root 'splash#index'

  resources :users, only: [:index] do
    resources :categories, only: [:index, :show, :new, :create] do # , :destroy, :show
      resources :expenses, only: [:index, :new, :create] do
        resources :category_expenses, only: [:index] do # , :new, :create, :destroy
        end
      end
    end
  end
end
