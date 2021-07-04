# frozen_string_literal: true

class Key < ApplicationRecord
  belongs_to :provider
  belongs_to :user

  has_secure_token :token
end
