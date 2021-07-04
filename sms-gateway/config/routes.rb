# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins

  paths_to_exclude =
    %w[
      api/v1
      admin/sign_in
      admin/sign_out
    ]

  root 'home#index'

  # Sidekiq web interface
  require 'sidekiq/web'
  authenticate :admin do
    mount Sidekiq::Web => '/sidekiq'
  end

  get '/*path',
      to:          'home#index',
      constraints: ->(req) { paths_to_exclude.all? { |path| req.path.exclude?(path) } }

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # API for internal requests
      namespace :admin do
        get 'admins', to: 'admins#index'
        post 'admins/create'

        get 'messages', to: 'messages#index'
        post 'messages/create'

        get 'providers/balance'
        get 'providers', to: 'providers#index'
        get 'providers/names'

        get 'statistics/balances'
        get 'statistics/charts'
        get 'statistics/info'
        get 'statistics/line_chart'

        get 'users/names'
        get 'users', to: 'users#index'
        post 'users/create'
      end

      # API available for users
      namespace :user do
        get 'messages/info', to: 'messages#show'
        get 'messages/new', to: 'messages#new'
      end
    end
  end
end
