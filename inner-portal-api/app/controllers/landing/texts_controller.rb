# frozen_string_literal: true

module Landing
  class TextsController < APIController
    def index
      data = {}
      Text.all.each { |text| data[text.section_name] = text.text }
      render json: data
    end
  end
end
