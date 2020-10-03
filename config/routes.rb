Rails.application.routes.draw do
  root 'pages#index'
  get '/terms', to: 'pages#terms'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
