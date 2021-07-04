# frozen_string_literal: true

# Если модель провайдера просто хранит какую-то информацию типа логина или токена,
#   то фабрика может собрать полноценный класс провайдера,
#   которой помимо этой информации будет иметь набор действий, присущих именно этому провайдеру
#   (типа отправка сообщений, проверка баланса и т.п.)
#
# Для каждого провайдера в папке /app/services/providers существует класс,
#   имя которого совпадает с именем провайдера
# Каждый такой класс имеет нарбор методов с одинаковыми названиями,
#   но при этом каждый набор описывает апи своего провайдера
# Собственно этот класс с набором методов и используется для сборки полноценного класса провайдера
module Providers
  module Factory
    def self.create_by_name(provider_name)
      # Находим класс нужного провайдера
      provider = "Providers::#{provider_name}".constantize.new

      # Находим модель провайдера и получаем названия колонок таблиц
      # Затем, используя эти названия, создаём провайдеру инстанстые переменные, которые хранят информацию из БД,
      #   а также геттеры на эти переменные
      provider_model = Provider.find_by!(name: provider_name)
      provider_attrs = Provider.column_names.map(&:to_sym)

      provider_attrs.each do |attr|
        variable_name = "@#{attr}"

        provider.instance_variable_set(variable_name, provider_model.__send__(attr))
        provider.define_singleton_method(attr) { provider.instance_variable_get(variable_name) }
      end

      provider
    end
  end
end
