# frozen_string_literal: true

module Providers
  # noinspection RubyResolve
  # If you cannot find an instance variable or method definition - it was defined by the factory
  class TeraSms < Base
    include Constants

    def initialize
      # Request parameters that will be the same for any request
      @headers = { "Content-Type": 'application/json' }
    end

    # ARI for checking balance:
    #   https://terasms.ru/documentation/api/http/check-balance
    def balance
      request = Request.new(
        provider_name: name,
        headers:       @headers,
        url:           'https://auth.terasms.ru/outbox/balance/json/',
        body:          { login: @login }
      )

      sign(request)

      response = request.post

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Balance Request Failure', request, response)
      end

      if response.body[:status] != API_RESPONSE_STATUSES[:success]
        raise CustomExceptions::UnexpectedApiResponse.new('Balance Request Failure', request, response)
      end

      response.body[:balance]
    end

    # API for sending a message
    #   https://terasms.ru/documentation/api/http
    def send_message(message_id)
      message     = Message.find(message_id)
      sender_name = Key.where(user: message.user, provider: message.provider).pluck(:sender_name)[0]

      request = Request.new(
        provider_name: name,
        headers:       @headers,
        url:           'https://auth.terasms.ru/outbox/send/json',
        body:          {
          login:   @login,
          sender:  sender_name || ENV['DEFAULT_SENDER_NAME'],
          target:  message.target,
          message: message.content
        }
      )

      sign(request)

      response = request.post

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Sending Message Failure', request, response)
      end

      if response.body[:status] != API_RESPONSE_STATUSES[:success]
        raise CustomExceptions::UnexpectedApiResponse.new('Sending Message Failure', request, response)
      end

      response.body[:message_infos].each do |message_info|
        message.update!(
          ext_id: message_info[:id],
          status: MESSAGE_STATUSES[message_info[:status]]
        )
      end
    end

    # API for statuses updating (also some additional information):
    #   https://terasms.ru/documentation/api/http/get-status
    def update_message_statuses(message_ids)
      ext_ids = Message.where(id: message_ids).pluck(:ext_id)

      request = Request.new(
        provider_name: name,
        headers:       @headers,
        url:           'https://auth.terasms.ru/outbox/getstatus/json',
        body:          { login: @login, message_ids: ext_ids }
      )

      sign(request)

      response = request.post

      unless response.success?
        raise CustomExceptions::ProviderNotReached.new('Message Statuses Update Failure', request, response)
      end

      # There is no status field id if everything is correct
      if response.body[:status].present?
        raise CustomExceptions::UnexpectedApiResponse.new('Message Statuses Update Failure', request, response)
      end

      response.body[:statuses].each do |message_info|
        message = Message.find_by!(ext_id: message_info[:message_id])
        message.update!(
          status:   MESSAGE_STATUSES[message_info[:status]],
          cost:     message_info[:price],
          operator: OPERATORS[message_info[:country]]
          # The :country field above contains not only country but also an operator name
          # A field's value looks like 'Россия МТС' so we could get operator name easy by regex
        )
      end
    end

    private

    # Signs a request. A sign is a secure replacement for a password
    # The encryption algorithm:
    #   https://terasms.ru/documentation/api/http/authorization
    def sign(request)
      # Key :message_ids contains an array, any other keys contain simple objects, e.g. strings
      # See the link above for nuances of encryption
      sorted_pairs      = request.body.except(:message_ids).sort
      string_to_encrypt = sorted_pairs.reduce('') { |acc, elem| "#{acc}#{elem.first}=#{elem.last}" }

      request.body[:message_ids]&.each&.with_index { |el, idx| string_to_encrypt += "#{idx}=#{el}" }

      encrypted_string = Digest::MD5.hexdigest(string_to_encrypt + @token)

      request.body.merge!(sign: encrypted_string)
    end
  end
end
