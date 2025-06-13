Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "folders#index", as: :authenticated_root
  end

  root "home#index"

  resources :folders, except: [:edit, :update] do
    resources :file_entries, only: [:create, :show, :destroy] do
      get :download, on: :member
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
