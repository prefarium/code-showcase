# frozen_string_literal: true

Rails.application.routes.draw do
  if ENV['SWAGGER']&.to_i == 1
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

  if ENV['SIDEKIQ']&.to_i == 1
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  mount ActionCable.server => '/websocket'
  mount Ckeditor::Engine => '/ckeditor'

  draw :admin
  draw :authentication
  draw :current
  draw :landing

  namespace :v1, defaults: { format: :json } do
    get 'selectors/event_types'
    get 'selectors/possible_assignees'

    get 'header/notification_numbers', to: 'headers#notification_numbers'

    post 'bot/send_invites', to: 'bots#send_invites'
    post 'bot/:token',       to: 'bots#webhook'

    resources :birthdays, only: :index do
      get 'upcoming', on: :collection
    end

    resource  :calendar,  only: :show
    resources :documents, only: :index
    resource  :feedback,  only: :create
    resources :news,      only: %i[index show create]
    resources :petitions, only: %i[create]
    resource  :survey,    only: :show
    resources :users,     only: %i[index show]

    # ----- События

    resources :events, only: %i[index show create update destroy] do
      get 'waiting_for_confirmation', on: :collection
      get 'processed',                on: :collection
      put 'update_status',            on: :member
    end

    # ----- Задачи

    get '/tasks/archive',     to: 'tasks_archives#index'
    get '/tasks/archive/:id', to: 'tasks_archives#show'

    resources :tasks, only: %i[index show create update destroy] do
      put 'update_status', on: :member
    end

    # ----- Идеи

    put 'ideas/:id/vote', to: 'votes#update'

    resources :pins,  only: %i[create destroy]
    resources :ideas, only: %i[index show create] do
      get 'aside',  on: :collection
      get 'pinned', on: :collection
      get 'search', on: :collection
    end

    # ----- Уведомления

    get    'notifications', to: 'notifications#index'
    put    'notifications', to: 'notifications#mark_as_read'
    delete 'notifications', to: 'notifications#clear'
  end
end
