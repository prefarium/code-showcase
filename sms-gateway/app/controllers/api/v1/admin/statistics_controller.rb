# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class StatisticsController < Base
        def balances
          provider_names = ::Provider.pluck(:name)
          balances       = provider_names.map do |name|
            {
              provider_name: name,
              balance:       Providers::Factory.create_by_name(name).balance
            }
          end

          render json: { balances: balances }
        end

        # TODO: split into two actions that return quantity and cost data separately
        def charts
          message_properties =
            {
              date:     :created_at,
              cost:     :cost,
              operator: :operator
            }

          result =
            {
              labels:   [],
              quantity: [],
              cost:     []
            }

          messages_data = filtered_messages.delivered.where.not(operator: nil).pluck(*message_properties.values)

          messages_data.map! do |message|
            message_properties.keys.zip(message).to_h
          end

          Message.operators.each_key do |oper|
            result[:labels] << Message::OPERATOR_NAME[oper]
            result[:quantity] << messages_data.count { |m| m[:operator] == oper }
            result[:cost] << messages_data.sum(0) { |m| m[:operator] == oper && m[:cost] ? m[:cost] : 0 }.round(2)
          end

          render json: result
        end

        def line_chart
          render json: { data: filtered_messages.group_by_day(:created_at).count }
        end

        def info
          result =
            {
              users:    { total: ::User.count },
              messages: {
                total: ::Message.count,
                today: {
                  successful:        ::Message.between_dates(Time.current).count,
                  with_server_error: ::Message.between_dates(Time.current).with_server_error.count
                }
              }
            }

          render json: result
        end
      end
    end
  end
end
