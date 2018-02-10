module Kirpich::Providers
  class GoogleImageCustomSearch
    BASE_URL = 'https://www.googleapis.com/customsearch/v1'.freeze

    class << self
      def search(q, page = 0)
        if !configured?
          Kirpich.logger.error "To use google custom search you shoud set kex and cx"
          return nil
        end

        q = clean(q)

        params = search_params(q, page)
        result = send_request(params)

        return unless result_valid?(result)

        img = result['items'].first['link']
        "#{img}?#{Time.now.to_i}"
      end

      def search_xxx(q, page = 0)
        q ||= 'girls'
        q += [' soft', ' softcore', ' sensuality'].sample

        search(q, page)
      end

      def api_key=(key)
        @api_key = key
      end

      def cx=(cx)
        @cx = cx
      end

      def configured?
        !(api_key.nil? || cx.nil?)
      end

      private

      attr_reader :api_key, :cx

      def send_request(params)
        response = Faraday.get(BASE_URL, params)
        result = JSON.parse response.body
        Kirpich.logger.info result

        result
      rescue RuntimeError => e
        Kirpich.logger.error e
        nil
      end

      def result_valid?(result)
        result.respond_to?(:key?) && \
          result.key?('items') && \
          result['items'].respond_to?(:any?) && \
          result['items'].any?
      end

      def search_params(q, page)
        params = {
          q: q,
          num: 1,
          searchType: :image,
          fileType: :jpg,
          imgSize: :large,
          key: api_key,
          cx: cx
        }
        params[:start] = page if page > 0

        if q =~ /(gif|гиф|гифку)/i
          params[:fileType] = :gif
          params[:q] = params[:q].gsub(/(gif|гиф|гифку)/i, '')
        end

        params
      end

      def clean(text)
        text.gsub(/(покажи|нам)/, '')
      end
    end
  end
end
