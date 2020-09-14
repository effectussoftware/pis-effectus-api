Rails.application.routes.draw do
  scope :admin do
    resources :communications
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
