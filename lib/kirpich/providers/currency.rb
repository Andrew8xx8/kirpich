module Kirpich::Providers
  class Currency
    class << self

      def usd_rub
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/selt.0/59109'
        { name: 'USD', rate: rate(url), emoji: '💵' }
      end

      def btc_usd
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/crypto.0/157694'
        { name: 'BTC', rate: rate(url), emoji: '₿' }
      end

      def eur_usd
        url = 'https://quote.rbc.ru/data/simple/delay/ticker/selt.0/59089'
        currency = rate(url)
        { name: 'EUR', rate: rate(url), emoji: '💶' }
      end

      def usd_rub_eur_rub_btc
        rates = []
        rates << usd_rub
        rates << btc_usd
        rates << eur_usd
        rates.compact
      end

      private

      def rate(url)
        response = Faraday.get(url)
        if response.success?
          data = JSON.parse(response.body).dig('result', 'data')
          data[0][7] if data
        end
      end
    end
  end
end
