# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class MessagesController < Base
        def index
          message_properties =
            {
              date:          :created_at,
              content:       :content,
              provider_name: 'providers.name',
              status:        :status,
              target:        :target,
              user_name:     'users.name'
            }

          total_pages   = (filtered_messages.count / 25.0).ceil
          messages_data = filtered_messages.order(created_at: :desc)
                                           .page(params[:page])
                                           .pluck(*message_properties.values)

          data_hashes = messages_data.map do |message|
            message_properties.keys.zip(message).to_h
          end

          sorted_data_hashes = data_hashes.sort_by { |el| el[:date] }.reverse

          render json: { total_pages: total_pages, messages: sorted_data_hashes }
        end

        def create
          if params[:user_id] != 1 && params[:user_id] != 5
            #  TODO: delete this in production
            return render json:   { error: 'В режиме демонстрации можно отправлять сообщения только от лица системы
                                            или Личного кабинета грузоперевозок!' },
                          status: :forbidden

          elsif params[:target].blank?
            return render json:   { error: 'Не указан номер получателя' },
                          status: :unprocessable_entity

          elsif !params[:target].match?(/\A79\d{9}\z/)
            return render json:   { error: 'Неверный формат номера' },
                          status: :unprocessable_entity

          elsif params[:content].blank?
            return render json:   { error: 'Не указан текст сообщения' },
                          status: :unprocessable_entity

          elsif params[:content].size > 100
            return render json:   { error: 'Текст сообщения не должен превышать 120 символов' },
                          status: :unprocessable_entity
          end

          provider_names = Provider.includes(:users).where(users: { id: params[:user_id] }).order(:id).pluck(:name)
          provider       = nil

          provider_names.each do |name|
            provider_instance = Providers::Factory.create_by_name(name)

            if Float(provider_instance.balance) > 10
              provider = provider_instance
              break
            end
          end

          unless provider
            return render json:   { error: 'У всех подключенных к клиенту провайдеров требуется пополнить счёт' },
                          status: :internal_server_error
          end

          message = Message.new(
            target:      params[:target],
            content:     params[:content],
            user_id:     params[:user_id],
            provider_id: provider.id
          )

          if message.save
            SendMessageJob.perform_later(message.id)
            render json: {}, status: :ok
          else
            render json: {}, status: :internal_server_error
          end
        end
      end
    end
  end
end
