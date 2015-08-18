module Kirpich::Providers
  class Text
    class << self

      def interfax
        get('http://www.interfax.ru/', ".text h3")
      end

      def ria
        get('http://ria.ru/', ".newsfeed_item .newsfeed_text")
      end


      def get(url, selector)
        response = Faraday.get url

        Nokogiri::HTML(response.body).css(selector).map(&:text).sample
      end

    end
  end
end

