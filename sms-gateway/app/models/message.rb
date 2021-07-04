# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :provider

  self.implicit_order_column = 'created_at'

  scope :between_dates,
        lambda { |from, to = from|
          period = Time.zone.parse(from.to_s).beginning_of_day..Time.zone.parse(to.to_s).end_of_day
          where(created_at: period)
        }

  enum status: {
    # -9..-1 - error statuses
    undefined: -2, # provider responded with unknown status
    error:     -1, # provider responded with an error
    # 0..9 - preparation statuses, a message hasn't been sent to a provider yet
    created:   0,  # just created
    queued:    1,  # passed to sidekiq
    # 10..19 - in-progress statuses, a message has been sent to a provider and/or being processed by them
    left:      10, # sent from sidekiq to a provider
    sent:      11, # sent from a provider to a recipient
    # 20..29 - final statuses, a message has been processed to its final state
    delivered: 20, # delivered to a recipient
    failed:    30, # cannot be delivered, e.g. the targeted phone number doesn't exist
    expired:   31, # not delivered after several attempts, e.g. the recipient's phone was turned off
    rejected:  32, # not delivered because of rejecting by a mobile operator, e.g. a spam filter
    unknown:   33  # sent, but a mobile operator not responded properly
  }

  scope :with_server_error, -> { where(status: -9..-1) }
  scope :preparing,         -> { where(status: 0..9) }
  scope :in_progress,       -> { where(status: 10..19) }
  scope :successful,        -> { where(status: 20..29) }
  scope :unsuccessful,      -> { where(status: 30..39) }

  enum operator: {
    other:   0,
    mts:     1,
    beeline: 2,
    megafon: 3,
    tele2:   4,
    yota:    5
  }

  OPERATOR_NAME = {
    other:   'Другой',
    mts:     'МТС',
    beeline: 'Билайн',
    megafon: 'Мегафон',
    tele2:   'Теле2',
    yota:    'Yota'
  }.stringify_keys.freeze

  public_constant :OPERATOR_NAME
end
