# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module User
      class MessagesController < ApplicationController
        def new
          missing_parameters = []
          %w[token target content].each { |key| missing_parameters << key unless params.key?(key) }

          unless missing_parameters.empty?
            error_message = "Missing #{'parameter'.pluralize(missing_parameters.size)}: " \
                            "#{missing_parameters.reduce { |acc, elem| acc + ", #{elem}" }}"

            return render json: { error: error_message }, status: :unprocessable_entity
          end

          key = Key.find_by(token: params[:token])
          return render json: { error: 'Unknown token' }, status: :unauthorized unless key

          message = Message.new(
            target:   params[:target],
            content:  params[:content],
            author:   key.user,
            provider: key.provider
          )

          if message.save
            SendMessageJob.perform_later(message.id)
            render json: {}, status: :ok
          else
            render json: {}, status: :internal_server_error
          end
        end

        def show
          return render json: { error: 'Missing parameter: ids' }, status: :unprocessable_entity if params[:ids].blank?

          # Create an array with info for each requested message
          # Result would look like this:
          #   [[message_id, { message_info }], [message_id, { message_info }], [message_id, { message_info }]]
          msg_infos = params[:ids].map do |id|
            [
              id,
              if id.match?(/^[\da-f]{8}-[\da-f]{4}-[\da-f]{4}-[\da-f]{4}-[\da-f]{12}$/) # Regex for UUID
                message = Message.find_by(id: id)

                if message
                  { target:  message.target,
                    content: message.content,
                    status:  message.status }
                else
                  { error: 'Message not found', error_code: 404 }
                end

              else
                { error: 'Incorrect message id', error_code: 422 }
              end
            ]
          end

          render json: { messages: msg_infos.to_h }
        end
      end
    end
  end
end
