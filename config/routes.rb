Rails.application.routes.draw do
  root "urls#index"
  resources :urls, only: [ :index, :new, :create ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "health" => "rails/health#show"

  # Wildcard must be last so it doesn't swallow /health, /up, etc.
  get "/:short_code", to: "redirects#show", as: :short_redirect
end
