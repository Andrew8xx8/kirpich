module Kirpich::Providers
  class Currency
    class << self
      def usd_rub
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/selt.0/59109'
        currency = ''
        response = Faraday.get(url)
        parsed_json = JSON.parse(response.body)
        data = parsed_json['result']['data']
        currency = data[0][7] if data
        { name: 'USD', rate: currency, emoji: '💵' }
      end

      def btc_usd
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/crypto.0/157694'
        currency = ''
        response = Faraday.get(url)
        parsed_json = JSON.parse(response.body)
        data = parsed_json['result']['data']
        currency = data[0][7] if data
        { name: 'BTC', rate: currency, emoji: '₿' }
      end

      def eur_usd
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/selt.0/59089'
        currency = ''
        response = Faraday.get(url)
        parsed_json = JSON.parse(response.body)
        data = parsed_json['result']['data']
        currency = data[0][7] if data
        { name: 'EUR', rate: currency, emoji: '💶' }
      end

      def usd_rub_eur_rub_btc
        rates = []
        rates << usd_rub
        rates << btc_usd
        rates << eur_usd
        rates
      end
    end
  end
end
