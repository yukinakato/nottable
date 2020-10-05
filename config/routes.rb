Rails.application.routes.draw do
  root 'pages#home'
  get '/terms', to: 'pages#terms'
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, only: :show do
    member do
      get 'bookmark'
    end
  end
  resources :notes
  get "notes/:id/pdf", to: "notes#create_pdf", as: :create_pdf
  resources :bookmarks, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resource :notifications, only: [:show, :destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
