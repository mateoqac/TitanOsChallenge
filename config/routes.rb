Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/contents#index"

  namespace :api do
    namespace :v1 do
      # Contents endpoints
      get "contents", to: "contents#index"
      get "contents/:id", to: "contents#show"

      # Search endpoint
      get "search", to: "search#index"

      # Favorites endpoints
      get "favorites/channel_programs", to: "favorites#channel_programs"
      get "favorites/apps", to: "favorites#apps"
      post "favorites/apps", to: "favorites#create_app_favorite"
    end
  end
end
