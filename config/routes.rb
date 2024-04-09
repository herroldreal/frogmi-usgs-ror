Rails.application.routes.draw do
  root "index#index"

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    get 'features', to: 'features#index'
    resource :features, path: 'features/:feature_id/comments', only: [:edit, :update, :create]
  end
end
