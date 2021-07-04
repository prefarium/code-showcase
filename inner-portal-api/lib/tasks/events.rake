# frozen_string_literal: true

namespace :events do
  desc 'Удаляет события со статусом "denied"'
  task destroy_denied: :environment do
    Event.denied.where('updated_at < ?', Time.current - 1.day).destroy_all
  end
end
