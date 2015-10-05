module Kirpich::Providers
  class Image
    class << self
      def les_400_image
        _extract_tumblr("http://les400culs.com/page/#{rand(200)}")
      end

      def lesaintdesseins_image
        _extract_tumblr("http://lesaintdesseins.fr/page/#{rand(200)}")
      end

      def _extract_tumblr(url)
        response = Faraday.get url

        Nokogiri::HTML(response.body).css('.post.photo > a img').map do |i|
          i['src']
        end.sample + "?#{Time.now.to_i}"
      end

      def developerslife_image
        response = Faraday.get 'http://developerslife.ru/random'
        link = response.headers['location']

        return unless link

        response = Faraday.get link
        page = Nokogiri::HTML(response.body)
        image = page.css('.entry .gif img')
        text = page.css('.entry .code .value')

        [image.first['src'], text.first.text.delete("'")] if image && text
      end
    end
  end
end
