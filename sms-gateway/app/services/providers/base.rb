# frozen_string_literal: true

module Providers
  class Base
    def send_message(message_id)
      Message.find(message_id).update!(
        ext_id:   rand(100_000_000..900_000_000),
        status:   :delivered,
        cost:     (rand * 10).round(2),
        operator: Message::OPERATOR_NAME.keys.sample
      )
    end
  end
end
