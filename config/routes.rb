# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts, only: %i[show new]
  root 'posts#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
