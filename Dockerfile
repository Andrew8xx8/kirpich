FROM ruby:2.2.1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY lib/kirpich/version.rb /usr/src/app/lib/kirpich/
COPY kirpich.gemspec /usr/src/app/
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

CMD 'bin/run'
