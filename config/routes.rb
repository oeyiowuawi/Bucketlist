require 'api_constraint'
Rails.application.routes.draw do
  namespace :api, path: '/', defaults: { format: :json } do
    post 'auth/login', to: 'sessions#login'
    get 'auth/logout', to: 'sessions#destroy'
    resources :users, only: :create

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :bucketlists do
        resources :items, only: [:create, :update, :destroy]
      end
    end
  end
end
