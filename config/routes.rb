# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"
Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :articles, only: %i[index show] do
    collection do
      get :cached_keys
    end
  end
  mount Sidekiq::Web => "/sidekiq"
end
