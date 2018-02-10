# Паша Кирпич. Бот

[![Build Status](https://travis-ci.org/Andrew8xx8/kirpich.svg)](https://travis-ci.org/Andrew8xx8/kirpich)
[![Coverage Status](https://coveralls.io/repos/Andrew8xx8/kirpich/badge.svg?branch=master&service=github)](https://coveralls.io/github/Andrew8xx8/kirpich?branch=master)

# ОТСТОРОЖНО! КОНТЕНТ 18+

Нет, серьезно, возможно вам не стоит дальше смотреть. Бот матерится, постит в чат фотографии эротического, а иногда совсем неприемлимого содержания и вообще ведет себя крайне дерзко.

Подумайте еще разок, нужен ли вам такой собеседник =)

## Демо
  https://telegram.me/PashaKirpichBot

## Запуск

### Telegram

Создать бота [инструкия тут](https://core.telegram.org/bots#3-how-do-i-create-a-bot). В процессе нужно получить API токен

Далее:

```
git clone git@github.com:Andrew8xx8/kirpich.git
cd kirpich
bundle install
TELEGRAM_TOKEN=ВашТокен bin/run
```

### Slack

Создать новую интеграцию типа [бот](https://my.slack.com/services/new/bot). Там сгенерируется API токен.

Далее:

```
git clone git@github.com:Andrew8xx8/kirpich.git
cd kirpich
bundle install
SLACK_TOKEN=ВашТокен bin/run
```

## Деплой

В репозитоии уже настроено все для деплоя на heroku, openshift.

Для работы нужно установть соотвтсвтеющие переменные окружения. Минимально необходимые SLACK_TOKEN или TELEGRAM_TOKEN.

https://devcenter.heroku.com/articles/config-vars
https://developers.openshift.com/en/managing-environment-variables.html

### Docker

Копируем `docker-compose.sample.yml` в `docker-compose.yml` и пишем свои токены туда.

Запускаем:

```
docker-compose run pashok
```

### Поиск картинок и видео

Пашка работает через Google Custom Search API. Чтобы все завелось нужно определить
две переменные окружения `GSE_API_KEY` и `GSE_CX`.

Процесс не простой, описан тут: http://stackoverflow.com/questions/34035422/google-image-search-says-api-no-longer-available/34062436#34062436. Удачи в общем =)
