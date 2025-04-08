# frozen_string_literal: true

Rails.application.routes.draw do
  root 'posts#index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    registrations: 'users/registrations' }
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
  resources :users do
    resource :profiles, only: %i[show edit update]
    resource :relationships, only: %i[create destroy]
    resources :bookmarks, only: %i[index create destroy], param: :post_id
  end
  resources :posts, only: %i[show new create] do
    resource :favorites, only: %i[create destroy]
    resource :reposts, only: %i[create destroy]
    resources :comments, only: %i[create destroy]
  end
  resources :messages, only: %i[create]
  resources :rooms, only: %i[index show create]
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
