# frozen_string_literal: true

namespace :landing, defaults: { format: :json } do
  resources :competences,    only: :index
  resources :header_cards,   only: :index
  resources :history_marks,  only: :index
  resources :news,           only: :index
  resources :members,        only: :index
  resources :projects,       only: %i[index show]
  resources :project_groups, only: %i[index show]
  resources :texts,          only: :index
end
