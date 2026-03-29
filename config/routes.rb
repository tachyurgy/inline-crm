Rails.application.routes.draw do
  root "dashboard#show"

  resources :contacts, except: [:edit] do
    resources :activities, only: [:create]
  end
  resources :companies, except: [:edit] do
    resources :activities, only: [:create]
  end
  resources :deals, except: [:edit] do
    member do
      patch :move
    end
    resources :activities, only: [:create]
  end
  resources :activities, only: [:index] do
    collection do
      get :feed
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
