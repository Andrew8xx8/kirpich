module Kirpich::Providers
  class Lurk
    class << self

      def search(text)
        return unless text

        text = _clean(text)
        path = _redirect_path(text)
        return unless path

        html = _load(path)
        return unless html

        page = Nokogiri::HTML(html)
        _extract(page)
      end

      def random
        html = _load('%D0%A1%D0%BB%D1%83%D0%B6%D0%B5%D0%B1%D0%BD%D0%B0%D1%8F:Random')
        return unless html

        page = Nokogiri::HTML(html)
        _extract(page)
      end

      def _extract(node)
        result = []

        images = node.css('img.thumbimage').map { |e| e['src'] }
        if images.any?
          result << "#{images.sample.gsub(/^\/\//, 'http://')}\n"
        end

        texts = node.css('#bodyContent>p').map { |e| e.text }

        if texts.any?
          result << "#{texts[0]}"
          result << "#{texts[1]}" if texts.length > 1
        end

        result
      end

      def _load(path)
        response = Faraday.get "http://lurkmore.to/#{path}"
        if response.headers[:location]
          response = Faraday.get response.headers[:location]
        end

        if response.body && !response.body.empty?
          response.body
        end
      end

      def _redirect_path(text)
        response = Faraday.get "http://lurkmore.to/index.php?title=#{text}"
        md = response.body.scan(/Please.*?\/(.*?)$/im)

        if md && md[0] && md[0][0]
          md[0][0]
        end
      end

      def _clean(text)
        text.strip.gsub(/ /, '_')
      end
    end
  end
end
