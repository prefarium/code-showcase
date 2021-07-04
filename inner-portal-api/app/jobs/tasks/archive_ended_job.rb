# frozen_string_literal: true

module Tasks
  class ArchiveEndedJob < ApplicationJob
    queue_as :default

    def perform
      Task.ended.destroy_all
    end
  end
end
