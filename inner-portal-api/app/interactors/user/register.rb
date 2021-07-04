# frozen_string_literal: true

class User
  class Register
    include Interactor::Organizer

    organize Create,
             UpdateAvatar,
             Dashboard::Create,
             NotificationSetting::Create,
             ResetToken::Encode,
             Update,
             SendWelcomeEmail
  end
end
