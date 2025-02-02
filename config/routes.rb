# frozen_string_literal: true

Rails.application.routes.draw do
  resource :users do
    resources :profiles, only: %i[show edit update]
  end
  resources :posts, only: %i[show new create] do
    resource :favorites, only: %i[create destroy]
    resources :reposts, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end
  root 'posts#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' }
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
