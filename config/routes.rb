Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      post '/auth/login', to: 'authentication#login'
      namespace :admin do
        resources :user , only:[:index,:show,:update]
      end
    end
  end
end
