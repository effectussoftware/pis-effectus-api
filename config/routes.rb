Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', only: [:destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/auth/login', to: 'authentication#login'
end
