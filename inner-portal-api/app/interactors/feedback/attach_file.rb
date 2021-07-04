# frozen_string_literal: true

class Feedback
  class AttachFile
    include Interactor

    ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png].freeze
    ALLOWED_FILE_TYPES    = %w[.jpeg .jpg .png].freeze
    WEIGHT_IN_BYTES       = ENV.fetch('FEEDBACK_ATTACHMENT_WEIGHT', 3).to_i * 2**20

    def call
      feedback = context.feedback
      file     = context.file

      return if file.blank?

      unless ALLOWED_CONTENT_TYPES.include?(file.content_type)
        context.fail!(
          error_message: I18n.t('errors.common.forbidden_image_type', image_types: ALLOWED_FILE_TYPES.join(', ')),
          status:        :unprocessable_entity
        )
      end

      if file.size > WEIGHT_IN_BYTES
        context.fail!(
          error_message: I18n.t('errors.common.attachment_too_heavy',
                                max_weight: helper.number_to_human_size(WEIGHT_IN_BYTES)),
          status:        :unprocessable_entity
        )
      end

      filename = "file#{Time.current.strftime('%Y%m%d%H%M%S')}"
      feedback.file.attach(io: file, filename: filename)
    end
  end
end
