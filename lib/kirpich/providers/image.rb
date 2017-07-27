module Kirpich::Providers
  class Image
    class << self
      def ass_image
        _extract_tumblr("http://hellasweetass.tumblr.com/page/#{rand(200)}")
      end

      def boobs_image
        _extract_tumblr("http://boobsarethegreatest.tumblr.com/page/#{rand(200)}")
      end

      def ass_perfection
        _extract_tumblr("http://ass-perfection-blog.tumblr.com/page/#{rand(200)}")
      end

      def _extract_tumblr(url)
        response = Faraday.get url

        Nokogiri::HTML(response.body).css('.photo img').map do |i|
          i['src']
        end.sample
      end

      def developerslife_image
        connection = Faraday.new(url: 'http://developerslife.ru/random'.freeze) do |faraday|
           faraday.use FaradayMiddleware::FollowRedirects, limit: 5
           faraday.adapter Faraday.default_adapter
        end
        response = connection.get

        page = Nokogiri::HTML(response.body)
        image = page.css('.entry .image .gif video source')
        text = page.css('.entry .code .value')

        [image.first['src'], text.first.text.delete("'")] if image.any? && text.any?
      end

      def devopsreactions_image
        response = Faraday.get('http://devopsreactions.tumblr.com/random'.freeze)
        response.headers['location'.freeze]
      end
    end
  end
end
