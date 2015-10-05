module Kirpich::Providers
  class Currency
    class << self
      def usd_rub_eur_rub
        response = Faraday.get 'https://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
        result = JSON.parse response.body

        rates = []
        result['query']['results']['rate'].each do |rate|
          name = rate['Name']
          rate = rate['Rate']
          rates << { name: name, rate: rate, emoji: _emoji(name) }
        end

        rates
      end

      def _emoji(name)
        if name =~ /USD/
          ':dollar:'
        else
          ':euro:'
        end
      end
    end
  end
end
