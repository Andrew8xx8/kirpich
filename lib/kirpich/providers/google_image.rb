module Kirpich::Providers
  class GoogleImage
    class << self
      def search(q, page = 0)
        _search(q, page)
      end

      def search_xxx(q, page = 0)
        q ||= 'girls'
        q += [' soft', ' softcore', ' sensuality'].sample

        _search(q, page)
      end

      def _search(q, page)
        q = _clean(q)

        params = _search_params(q, page)
        result = _send_request(params)

        return unless _result_valid?(result)

        img = result['responseData']['results'].first['unescapedUrl']
        "#{img}?#{Time.now.to_i}"
      end

      def _send_request(params)
        response = Faraday.get('http://ajax.googleapis.com/ajax/services/search/images', params)
        result = JSON.parse response.body
        Kirpich.logger.info result

        result
      rescue RuntimeError => e
        Kirpich.logger.error e
        nil
      end

      def _result_valid?(result)
        result.respond_to?(:key?) && \
          result.key?('responseData') && \
          result['responseData'].respond_to?(:key?) && \
          result['responseData'].key?('results') && \
          result['responseData']['results'].any?
      end

      def _search_params(q, page)
        params = { q: q, rsz: '1', v: '1.0', as_filetype: 'jpg', imgsz: 'large' }
        params[:start] = page if page > 0

        if q =~ /(gif|гиф|гифку)/i
          params[:as_filetype] = 'gif'
          params[:q] = params[:q].gsub(/(gif|гиф|гифку)/i, '')
        end

        params
      end

      def _clean(text)
        text.gsub(/(покажи|нам)/, '')
      end
    end
  end
end
