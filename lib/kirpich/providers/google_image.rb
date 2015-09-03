module Kirpich::Providers
  class GoogleImage
    class << self
      def search(q, random = false)
        _search(q, random)
      end

      def search_xxx(q, random = false)
        q ||= 'girls'
        q += [' soft', ' softcore', ' sensuality'].sample

        _search(q, random)
      end

      def _search(q, random)
        q = _clean(q)

        params = _search_params(q, random)
        response = Faraday.get('http://ajax.googleapis.com/ajax/services/search/images', params)
        result = JSON.parse response.body
        Kirpich.logger.info result

        if result.key?("responseData") && result["responseData"].key?("results")
          img = if random
            result["responseData"]["results"].sample["unescapedUrl"]
          else
            result["responseData"]["results"].first["unescapedUrl"]
          end

          "#{img}?#{Time.now.to_i}"
        end
      rescue NoMethodError => e
        Kirpich.logger.error e
        ''
      rescue RuntimeError => e
        Kirpich.logger.error e
        ''
      end


      def _search_params(q, random)
        params = { q: q, rsz: '8', v: '1.0', as_filetype: 'jpg', imgsz: 'large' }
        params[:start] = rand(50) if random

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
