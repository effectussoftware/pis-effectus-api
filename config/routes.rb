# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :device_registrations, only: %i[create]
      mount_devise_token_auth_for 'User', at: 'auth'
      post '/auth/login', to: 'authentication#login'
      resources :communications, only: %i[show]
      resource :feed, only: %i[show]
      namespace :admin do
        resources :users, only: %i[index show update]
        post '/auth/login', to: 'authentication_admin#login'
        resources :communications
      end
    end
  end
end
