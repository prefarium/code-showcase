# frozen_string_literal: true

namespace :v1, defaults: { format: :json } do
  namespace :current do
    resource :avatar,    only: :update
    resource :dashboard, only: %i[show update]
    resource :password,  only: :update
    resource :user,      only: :show

    put 'settings', to: 'settings#update'
  end
end
