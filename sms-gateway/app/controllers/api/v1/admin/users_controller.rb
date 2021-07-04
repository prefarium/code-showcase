# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class UsersController < Base
        def index
          result_params =
            {
              name:            'users.name',
              provider_name:   'providers.name',
              sender_name:     'keys.sender_name',
              connection_date: 'keys.created_at',
              token:           'keys.token'
            }

          raw_results = ::User.with_id(params[:user_id])
                              .with_provider(params[:provider_id])
                              .connected_at(params[:date_from], params[:date_to])
                              .includes(:keys, :providers)
                              .pluck(*result_params.values)
                              .group_by(&:shift)

          result = raw_results.map do |raw|
            user_info = { name: raw[0], info: [] }
            keys_info = raw[1]

            keys_info.each do |info|
              user_info[:info] << result_params.except(:name).keys.zip(info).to_h
            end

            user_info
          end

          render json: result
        end

        def names
          result_keys = %i[id name]
          users       = ::User.pluck(*result_keys)
          result      = users.map { |user| result_keys.zip(user).to_h }

          render json: result
        end

        def create
          possible_blank_fields =
            {
              user_name:   'Не указано название клиента',
              provider_id: 'Не выбран провайдер для отправки сообщений',
              sender_name: 'Не указано желаемое имя отправителя'
            }

          possible_blank_fields.each_pair do |key, error_message|
            if params[key].blank?
              return render json:   { error: error_message },
                            status: :unprocessable_entity
            end
          end

          user     = ::User.create!(name: params[:user_name])
          provider = ::Provider.find(params[:provider_id])

          ::Key.create!(user: user, provider: provider, sender_name: provider.default_sender_name)
          ::SenderNameRequest.create!(user: user, provider: provider, name: params[:sender_name])

          render json: {}
        end
      end
    end
  end
end
