Проекты, сделанные мною для работы. 
Токены, ссылки на прод и другая внутренняя информация или удалена, или заменена на `__deleted__`.
Версии кода также удалены, так как они хранили всю эту информацию

# SMS Gateway
## Описание
Апи-сервис, через который наши внутренние приложения могли заниматься смс-рассылкой
На вход он получал данные для отправки и имя желаемого провайдера (типа terasms). Благодаря
использованию фабричного метода, сервис мог легко масштабироваться - фабрика строила инстанс
выбранного провайдера и отправляла сообщение через него. Все смс логировались и на их основе
строились chartjs-графики
## Возможные улучшения
* Вынести весь захардкоженный текст в локали
* Вынести некоторые проверки при создании объектов в контроллерах в валидации
* Создать общий метод для рендера ошибок
* Добавить тесты
* Добавить документацию

# Inner portal API
## Описание
Бэкенд для внутреннего портала. Что в нём есть в общих чертах:
* JWT-аутентификация
* Интеграция со своим ботом телеграма
* Самописная ролевая система, напоминащая Pundit
* Email-уведомления и отправляемые по весокетам уведомления о действиях коллег
* Календарь для создания событий и согласования отгулов с отпусками, 
  получение и назначение задач, 
  идеи и голосование за них
* Интеракторы
* Админка на administrate
* Докер
## Возможные улучшения
* Нужно частично переписать админку, 
  чтобы вместо непосредственной кастомизации вьюх использовались кастомные поля
* Переписать пару контроллеров так, чтобы они начали соблюдать принцип разделения интерфейсов
* Добавить больше тестов
* Добавить документацию
