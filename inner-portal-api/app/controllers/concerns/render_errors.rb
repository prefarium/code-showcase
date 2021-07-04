# frozen_string_literal: true

module RenderErrors
  def bot_unauthorized
    render_error(I18n.t('errors.bot.unauthorized'), :unauthorized)
  end

  def incorrect_query_parameter(error)
    render_error(error.message, :unprocessable_entity)
  end

  def not_authorized
    render_error(I18n.t('errors.common.not_authorized'), :unauthorized)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end

  def render_error_from_context(context)
    render_error(context.error_message, context.error_status || :unprocessable_entity)
  end

  # Ответ в таком формате сообщает фронту, что не надо отрисовывать запрошенный блок
  # Личная просьба Данила Антоновича
  def hide_requested_section
    render json: { resources: '__FORBIDDEN__' }
  end
end
