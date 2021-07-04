# frozen_string_literal: true

class UpdateMessageStatusesJob < ApplicationJob
  queue_as :default

  # Сначала выбираем имена всех провайдеров,
  #   у которых есть сообщения со статусами "в процессе отправки" (in progress)
  # Затем в цикле, отдельно для каждого провайдера, выбираем id всех сообщения, которые требуют обновления;
  #   а дальше всё должно быть понятно
  def perform
    provider_models = Provider.joins(:messages)
                              .where('messages.status BETWEEN ? AND ?', 10, 19)
                              .distinct('providers.name')

    provider_models.each do |model|
      ids_to_update = model.messages.where(status: 10..19).ids
      provider      = Providers::Factory.create_by_name(model.name)

      provider.update_message_statuses(ids_to_update)
    end
  end
end
