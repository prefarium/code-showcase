# frozen_string_literal: true

class User
  module Password
    class RequestResetLink
      include Interactor::Organizer

      organize ResetToken::Encode, Update, Mailer::SendLinkForPasswordReset
    end
  end
end
