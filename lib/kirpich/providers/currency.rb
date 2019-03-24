module Kirpich::Providers
  class Currency
    class << self
      def currency_url(currency_id)
        "http://world.investfunds.ru/ajax/graph.currency.php?q=#{currency_id}"
      end

      def usd_rub
        url = currency_url(493)
        currency = ''
        response = Faraday.get(url)
        parsed_json = JSON.parse(response.body)
        currency = parsed_json[0]['data'].last[1] if parsed_json[0]['data']
        { name: 'USD', rate: currency, emoji: '💵' }
      end

      def eur_usd
        url = currency_url(495)
        currency = ''
        response = Faraday.get(url)
        parsed_json = JSON.parse(response.body)
        currency = parsed_json[0]['data'].last[1] if parsed_json[0]['data']
        { name: 'EUR', rate: currency, emoji: '💶' }
      end

      def usd_rub_eur_rub_btc
        rates = []
        rates << usd_rub
        rates << eur_usd
        rates
      end
    end
  end
end
