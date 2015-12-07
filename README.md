# Паша Кирпич. Slack-бот

[![Build Status](https://travis-ci.org/Andrew8xx8/kirpich.svg)](https://travis-ci.org/Andrew8xx8/kirpich)
[![Coverage Status](https://coveralls.io/repos/Andrew8xx8/kirpich/badge.svg?branch=master&service=github)](https://coveralls.io/github/Andrew8xx8/kirpich?branch=master)

# ОТСТОРОЖНО! КОНТЕНТ 18+

Нет, серьезно, возможно вам не стоит дальше смотреть. Бот матерится, постит в чат фотографии эротического, а иногда совсем неприемлимого содержания и вообще ведет себя крайне дерзко.

Подумайте еще разок, нужен ли вам такой собеседник =)

## Запуск

Создать новую интеграцию типа [бот](https://my.slack.com/services/new/bot). Там сгенерируется API токен.

Далее:

```
git clone git@github.com:Andrew8xx8/kirpich.git
cd kirpich
bundle install
TOKEN=ВашТокен bundle exec ruby ./run.rb
```

## Деплой

В репозитоии уже настроено все для деплоя на heroku или openshift.

Едиснственное что нужно установить переменную окружения TOKEN с вашим токеном.

https://devcenter.heroku.com/articles/config-vars
https://developers.openshift.com/en/managing-environment-variables.html

### Docker

Копируем `docker-compose.sample.yml` в `docker-compose.yml` и пишем свой токен туда.

Запускаем:

```
docker-compose run pashok
```

### Поиск картинок и видео

Пашка работает через Google Custom Search API. Чтобы все завелось нужно определить
две переменные окружения `GSE_API_KEY` и `GSE_CX`.

Процесс не простой, описан тут: http://stackoverflow.com/questions/34035422/google-image-search-says-api-no-longer-available/34062436#34062436. Удачи в общем =)

## Паша...

### ...знает мемы

![Паша кирпич объясняет суть мема](https://dl.dropboxusercontent.com/u/4256669/kirpich.png)

### ...в курсе дел

![Паша отвечает за дела](https://dl.dropboxusercontent.com/u/4256669/kirpich2.png)

### ...любит пироги

![Паша любит пироги](https://dl.dropboxusercontent.com/u/4256669/kirpich3.png)

### ...следит за финансами

![Паша любит следит за финансами](https://dl.dropboxusercontent.com/u/4256669/kirpich4.png)

### ...знает толк в женщинах

![Паша любит женщин](https://dl.dropboxusercontent.com/u/4256669/kirpich5.png)

### ...может показать хороший пример

![Паша показывает хороший пример](https://dl.dropboxusercontent.com/u/4256669/kirpich6.png)


