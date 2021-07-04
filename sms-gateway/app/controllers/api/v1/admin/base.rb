# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class Base < ApplicationController
        before_action :authenticate_admin!

        private

        def filtered_messages
          messages = ::Message

          if params[:date_from] && params[:date_to]
            messages = messages.between_dates(params[:date_from], params[:date_to])
          end

          messages = messages.where(provider_id: params[:provider_id]) if params[:provider_id]
          messages = messages.__send__(params[:status])                if params[:status]
          messages = messages.where(target: params[:target])           if params[:target]&.match?(/\d{11}/)
          messages = messages.where(user_id: params[:user_id])         if params[:user_id]

          messages.includes(:provider, :user)
        end
      end
    end
  end
end
