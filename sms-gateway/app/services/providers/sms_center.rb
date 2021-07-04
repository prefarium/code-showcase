# frozen_string_literal: true

module Providers
  class SmsCenter < Base
    include Constants

    # https://smsc.ru/api/http/balance/get_balance/
    def balance
      request = Request.new(
        provider_name: name,
        url:           'https://smsc.ru/sys/balance.php',
        body:          {
          login: @login,
          psw:   @password,
          fmt:   3
        }
      )

      response = request.get

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Balance Request Failure', request, response)
      end

      unless response.body[:balance]
        raise CustomExceptions::UnexpectedApiResponse.new('Balance Request Failure', request, response)
      end

      response.body[:balance]
    end

    # https://smsc.ru/api/
    def send_message(message_id)
      message     = Message.find(message_id)
      sender_name = Key.where(user: message.user, provider: message.provider).pluck(:sender_name)[0]

      request = Request.new(
        provider_name: name,
        url:           'https://smsc.ru/sys/send.php',
        body:          {
          login:  @login,
          psw:    @password,
          fmt:    3,
          cost:   2,
          phones: message.target,
          mes:    message.content,
          id:     message.id
        }
      )

      request.body[:sender] = sender_name if sender_name.present?

      response = request.get

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Sending Message Failure', request, response)
      end

      if response.body[:error]
        raise CustomExceptions::UnexpectedApiResponse.new('Sending Message Failure', request, response)
      end

      message.update!(
        ext_id: response.body[:id],
        status: :left,
        cost:   Float(response.body[:cost])
      )
    end

    # https://smsc.ru/api/http/status_messages/check_status/
    def update_message_statuses(message_ids)
      info_to_request = Message.where(id: message_ids).pluck(:target, :ext_id)
      targets         = info_to_request.reduce('') { |acc, elem| acc.empty? ? elem[0].to_s : "#{acc},#{elem[0]}" }
      ext_ids         = info_to_request.reduce('') { |acc, elem| acc.empty? ? elem[1].to_s : "#{acc},#{elem[1]}" }

      request = Request.new(
        provider_name: name,
        url:           'https://smsc.ru/sys/status.php',
        body:          {
          login: @login,
          psw:   @password,
          fmt:   3,
          phone: targets,
          id:    ext_ids
        }
      )

      response = request.get

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Message Statuses Update Failure', request, response)
      end

      if response.body.instance_of?(Hash) && response.body[:error]
        raise CustomExceptions::UnexpectedApiResponse.new('Message Statuses Update Failure', request, response)
      end

      if response.body.instance_of?(Array)
        response.body.each do |message_info|
          message       = Message.find_by!(ext_id: message_info[:id])
          operator_info = request_operator_for message

          message.update!(
            status:   MESSAGE_STATUSES[message_info[:status]],
            operator: operator_info ? OPERATORS[operator_info[:operator]] : nil
          )
        end

      else
        message       = Message.find(message_ids[0])
        operator_info = request_operator_for message

        message.update!(
          status:   MESSAGE_STATUSES[response.body[:status]],
          operator: operator_info ? OPERATORS[operator_info[:operator]] : nil
        )
      end
    end

    private

    def request_operator_for(message)
      request = Request.new(
        provider_name: name,
        url:           'https://smsc.ru/sys/info.php',
        body:          {
          get_operator: 1,
          login:        @login,
          psw:          @password,
          phone:        message.target,
          fmt:          3
        }
      )

      response = request.get

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Message Operator Update Failure', request, response)
      end

      if response.body[:error]
        raise CustomExceptions::UnexpectedApiResponse.new('Message Operator Update Failure', request, response)
      end

      response.body
    rescue StandardError
      false
    end
  end
end
