# frozen_string_literal: true

class UpdateSenderNameJob < ApplicationJob
  queue_as :default

  def perform(sender_name_id, status)
    return false unless %i[approved denied].include?(status)

    sender_name_request = SenderNameRequest.find(sender_name_id)
    sender_name_request.update!(status: status)

    # rubocop:disable Style/GuardClause
    # Cop is triggered incorrectly, guard clause is already used
    if sender_name_request == :approved
      user = sender_name_request.user
      user.update!(sender_name: sender_name_request.name)
    end
    # rubocop:enable Style/GuardClause
  end
end
