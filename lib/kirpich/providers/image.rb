module Kirpich::Providers
  class Image
    class << self
      def gusar_image(from, to, boobs, butt)
        url = "http://g5r.ru/api/images/random?q[nsfw_lt]=#{to}&q[nsfw_gt]=#{from}"
        url += "&q[boobs_gt]=0.95" if boobs
        url += "&q[butt_gt]=0.95" if butt

        response = Faraday.get(url)
        json = JSON.parse(response.body)
        json['picture_url']
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
