# Запуск сервера в докере
1. На основе `.env.example` создать `.env`
2. Запустить контейнер "раннер", внутри него установить гемы и создать базу
```
docker-compose run runner
bundle config path 'vendor/bundle' --local
bundle
rails db:prepare
exit
```
3. Запустить сервер `docker-compose up server`

# Запуск сервера не в докере
1. Поставить руби 2.7.3, постгрес, редис, ImageMagick
2. На основе `.env.example` создать `.env`
3. На основе `Procfile.example` создать `Procfile`
4. Выполнить:
```
bundle
rails db:create db:migrate
rails data:migrate
rails db:seed
```
5. Поставить что-нибудь, что работает с прокфайлами (типа overmind или foreman)
6. Запустить проект. 
   Если стоит overmind, то `overmind s -N`, если foreman, то `foreman start`. 
   Иначе просто в разных вкладках терминала выполнить команды из прокфайла 
