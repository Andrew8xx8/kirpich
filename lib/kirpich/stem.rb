require 'yandex_mystem'

module Kirpich
  class Stem < YandexMystem::Simple
    ARGUMENTS = '-l -g -d -e utf-8 -i --format json'

    def self.parse(data)
      as_json(data).first
    end
  end
end
