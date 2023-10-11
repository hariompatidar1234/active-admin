# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config
  # ActiveAdmin.routes(self)

  resources :users, only: %i[index create] do
    post 'login', on: :collection
    post 'forgot_password', on: :collection
    post 'reset_password', on: :collection
  end

  resource :profile, controller: 'users', only: %i[show update destroy], as: 'current_user_profile'

  resources :categories, only: %i[index show create update destroy]

  resources :restaurants, only: %i[index show create update destroy] do
    get 'my_restaurants_list', on: :collection
  end

  resources :carts, only: %i[index show create update destroy] do
    delete 'destroy_all', on: :collection
  end

  resources :dishes, only: %i[index create show update destroy] do
    collection do
      get 'owner_dishes'
      get 'filter', action: :index
    end
  end

  resources :orders, only: %i[index show create]
end
