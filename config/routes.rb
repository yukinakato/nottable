Rails.application.routes.draw do
  root 'pages#home'
  get '/terms', to: 'pages#terms'
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, only: :show

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
