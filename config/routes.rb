# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :device_registrations, only: %i[create]
      mount_devise_token_auth_for 'User', at: 'auth'
      post '/auth/login', to: 'authentication#login'
      resource :feed, only: %i[show]
      resource :priority_feed, only: %i[show]
      resources :reviews, only: %i[index show]
      resources :communications, only: %i[show]
      resources :events, only: %i[index show]
      resources :invitations, only: %i[update] do
        put :update_change_last_seen, on: :member
      end
      namespace :admin do
        resource :cost_summary, only: %i[show]
        resources :events, only: %i[index create show update]
        resources :users, only: %i[index show update]
        resources :reviews, only: %i[index create show update destroy]
        resources :surveys, only: %i[index create show update destroy]
        resources :questions, only: %i[index create show update destroy]
        resources :answers, only: %i[index create show update destroy]
        resources :multiple_choice_questions, only: %i[index create show update]
        post '/auth/login', to: 'authentication_admin#login'
        resources :communications, only: %i[index create show update destroy]
      end
    end
  end
end
 