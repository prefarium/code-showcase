# frozen_string_literal: true

class User
  module Password
    class Reset
      include Interactor::Organizer

      organize ResetToken::Decode, Update
    end
  end
end
