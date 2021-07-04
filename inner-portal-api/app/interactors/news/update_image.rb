# frozen_string_literal: true

class News
  class UpdateImage
    include Interactor

    ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png].freeze
    ALLOWED_FILE_TYPES    = %w[.jpeg .jpg .png].freeze
    WIDTH                 = ENV.fetch('NEWS_IMAGE_WIDTH', 1920).to_i
    HEIGHT                = ENV.fetch('NEWS_IMAGE_HEIGHT', 800).to_i

    def call
      image = context.image
      news  = context.news

      return if image.blank?

      unless ALLOWED_CONTENT_TYPES.include?(image.content_type)
        context.fail!(
          error_message: I18n.t('errors.common.forbidden_image_type', image_types: ALLOWED_FILE_TYPES.join(', ')),
          status:        :forbidden
        )
      end

      opened_image = MiniMagick::Image.open(image.path)
      new_image    = ImageCropper.resize_with_crop(opened_image, WIDTH, HEIGHT)

      File.open(new_image.path) do |file|
        filename = "image#{Time.current.strftime('%Y%m%d%H%M%S')}"
        news.image.attach(io: file, filename: filename)
      end
    end
  end
end
