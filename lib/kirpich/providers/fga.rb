module Kirpich::Providers
  class Fga
    class << self
      def random
        response = Faraday.get 'http://fucking-great-advice.ru/api/random'
        json = JSON.parse(response.body)
        Nokogiri::HTML(json['text']).text
      end
    end
  end
end
