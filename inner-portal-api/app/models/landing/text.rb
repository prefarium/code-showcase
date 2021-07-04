# frozen_string_literal: true

module Landing
  class Text < ApplicationRecord
    enum section_name: {
      about_us:    1,
      header_text: 2,
      about_portal:  3
    }
  end
end
