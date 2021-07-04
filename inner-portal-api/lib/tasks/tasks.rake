# frozen_string_literal: true

namespace :tasks do
  desc 'Убирает в архив задачи со статусом "завершена" или "отказ"'
  task(archive_ended: :environment) { Tasks::ArchiveEndedJob.perform_later }
end
