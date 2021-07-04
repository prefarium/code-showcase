# frozen_string_literal: true

class User
  class UpdateAvatar
    include Interactor

    ALLOWED_CONTENT_TYPES = %w[image/jpeg image/png].freeze
    ALLOWED_FILE_TYPES    = %w[.jpeg .jpg .png].freeze
    WIDTH                 = ENV.fetch('AVATAR_WIDTH', 400).to_i
    HEIGHT                = ENV.fetch('AVATAR_HEIGHT', 400).to_i

    def call
      avatar = context.avatar
      user   = context.user

      return if avatar.blank?

      unless ALLOWED_CONTENT_TYPES.include?(avatar.content_type)
        context.fail!(
          error_message: I18n.t('errors.common.forbidden_image_type', image_types: ALLOWED_FILE_TYPES.join(', ')),
          status:        :forbidden
        )
      end

      avatar_image = MiniMagick::Image.open(avatar.path)
      new_avatar   = ImageCropper.resize_with_crop(avatar_image, WIDTH, HEIGHT)

      File.open(new_avatar.path) do |file|
        filename = "avatar#{Time.current.strftime('%Y%m%d%H%M%S')}"
        user.avatar.attach(io: file, filename: filename)
      end
    end
  end
end
