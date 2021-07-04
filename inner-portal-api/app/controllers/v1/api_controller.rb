# frozen_string_literal: true

module V1
  class APIController < ActionController::API
    include JWTSessions::RailsAuthorization
    include RenderErrors

    before_action :authorize_by_access_header!

    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
    rescue_from IncorrectQueryParameter, with: :incorrect_query_parameter

    private

    def current_user
      @current_user ||= User.find(payload['user_id'])
    end

    def permit_params(*args)
      hash = params.permit(*args).to_h.deep_symbolize_keys
      hash.each_pair { |k, v| hash[k] = ActiveModel::Type::Boolean.new.cast(v) if %w[true false].include?(v) }
    end

    def user
      @user ||= User.find_by(id: params[:user_id]) || current_user
    end

    def search_query
      @search_query ||= params[:search_query]
    end
  end
end
