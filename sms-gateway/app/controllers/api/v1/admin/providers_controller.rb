# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class ProvidersController < Base
        def balance
          if params[:provider_name].blank?
            return render json: { error: 'Missing parameter: provider_name' }, status: :unprocessable_entity
          end

          begin
            provider = Providers::Factory.create_by_name(params[:provider_name])
          rescue NameError
            return render json: { error: 'Provider not present' }, status: :not_found
          rescue ActiveRecord::RecordNotFound
            return render json: { error: 'Provider info not found in DB' }, status: :not_found
          end

          begin
            render json: provider.balance
          rescue CustomExceptions::ProviderNotReached
            render json: { error: 'Cannot reach provider' }, status: :internal_server_error
          rescue CustomExceptions::UnexpectedApiResponse
            render json: { error: 'Unexpected response from a provider' }, status: :internal_server_error
          end
        end

        def index
          providers = Provider.all
          result    = providers.map do |provider|
            {
              name:    provider.name,
              date:    provider.created_at,
              balance: Providers::Factory.create_by_name(provider.name).balance
            }
          end

          render json: result
        end

        def names
          result_keys = %i[id name]
          providers   = ::Provider.pluck(*result_keys)
          result      = providers.map { |provider| result_keys.zip(provider).to_h }
          render json: result
        end
      end
    end
  end
end
