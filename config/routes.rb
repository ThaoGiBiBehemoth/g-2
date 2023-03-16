Rails.application.routes.draw do
  resources :users
  resources :tasks
  post "/login", to: "users#login"
end
