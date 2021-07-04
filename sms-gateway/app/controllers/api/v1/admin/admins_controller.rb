# frozen_string_literal: true

module Api
  # noinspection RubyClassModuleNamingConvention
  module V1
    module Admin
      class AdminsController < Base
        def index
          admins_data = ::Admin.pluck(:created_at, :email).map { |admin| { date: admin[0], email: admin[1] } }
          render json: { admins: admins_data }
        end

        def create
          if params[:email].blank?
            return render json:   { error: 'Не указана электронная почта' },
                          status: :unprocessable_entity

          elsif !params[:email].match?(/\A\w{3,80}@[a-z]{3,80}\.[a-z]{3,80}\z/)
            return render json:   { error: 'Неверный формат электронной почты' },
                          status: :unprocessable_entity

          elsif params[:password].blank?
            return render json:   { error: 'Не указан пароль' },
                          status: :unprocessable_entity

          elsif params[:password].size < 6
            return render json:   { error: 'Пароль должен содержать хотя бы 6 символов' },
                          status: :unprocessable_entity
          end

          ::Admin.create!(email: params[:email], password: params[:password])

          render json: {}
        end
      end
    end
  end
end
