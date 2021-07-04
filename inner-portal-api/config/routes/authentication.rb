# frozen_string_literal: true

namespace :v1, defaults: { format: :json } do
  post   'refresh', to: 'authentication/refresh#create'
  post   'login',   to: 'authentication/sessions#create'
  delete 'logout',  to: 'authentication/sessions#destroy'

  get  'password/new', to: 'authentication/passwords#new'
  post 'password',     to: 'authentication/passwords#create'
end
