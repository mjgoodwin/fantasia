Rails.application.routes.draw do
  root to: 'home#index'

  resources :users
  resources :leagues

  get  "sessions/sign_up_form"
  post "sessions/sign_up"
  get  "sessions/sign_out"

  get  "sessions/sign_in_form"
  post "sessions/sign_in"
end
