# frozen_string_literal: true

class User < ApplicationRecord
  has_many :keys, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :providers, through: :keys
  has_one :sender_name_request, dependent: :destroy

  scope :connected_at,
        lambda { |from, to = from|
          if from.instance_of?(String)
            includes(:keys)
              .where(keys: { created_at: Time.zone.parse(from).beginning_of_day..Time.zone.parse(to).end_of_day })
          elsif from.instance_of?(Time)
            includes(:keys)
              .where(keys: { created_at: from.beginning_of_day..to.end_of_day })
          end
        }

  scope :with_id, ->(id) { where(id: id) if id }
  scope :with_provider, ->(id) { includes(:providers).where(providers: { id: id }) if id }
end
