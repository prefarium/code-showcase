# frozen_string_literal: true

all = %i[index show new create edit update destroy]

namespace :admin do
  resources :controls,  only: all
  resources :divisions, only: all
  resources :documents, only: all
  resources :feedbacks, only: %i[index show edit update destroy]
  resources :events,    only: all
  resources :news,      only: all
  resources :petitions, only: %i[index show edit update]
  resources :positions, only: all
  resources :surveys,   only: %i[index show new create edit update]
  resources :users,     only: all

  root to: 'users#index'

  namespace :landing do
    resources :binds,          only: all
    resources :competences,    only: all
    resources :header_cards,   only: all
    resources :history_marks,  only: all
    resources :group_binds,    only: all
    resources :members,        only: all
    resources :projects,       only: all
    resources :project_groups, only: all
    resources :texts,          only: all
  end
end
