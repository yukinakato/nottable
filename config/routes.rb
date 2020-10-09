Rails.application.routes.draw do
  root "pages#home"
  get "/terms", to: "pages#terms"
  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  devise_scope :user do
    get "/guestmode", to: "sessions#guest_sign_in"
    get "/users/edit/password", to: "registrations#edit_password"
    patch "/users/edit/password", to: "registrations#update_password"
  end
  resources :users, only: :show do
    member do
      get "bookmark"
    end
  end
  resources :notes do
    collection do
      post "search"
    end
  end
  get "notes/:id/pdf", to: "notes#create_pdf", as: :create_pdf
  resources :bookmarks, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resource :notifications, only: [:show, :destroy]
end
