Rails.application.routes.draw do
  root "dashboard#show"

  resources :contacts, except: [:edit]
  resources :companies, except: [:edit]
  resources :deals, except: [:edit] do
    member do
      patch :move
    end
  end
  resources :activities, only: [:index] do
    collection do
      get :feed
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
