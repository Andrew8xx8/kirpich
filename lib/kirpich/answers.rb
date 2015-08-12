require 'nokogiri'
require 'open-uri'
require 'json'

module Kirpich
  class Answers
    def no_fap
      Kirpich::NO_FAP.sample
    end

    def materialize(text)
      result = []
      text.split(' ').each do |word|
        if word != 'материализуй'
          result << word

          if word.size > 3 && !(word =~ /[,.:;!?'\"\/#$%^&*()]/) && rand(7) == 5
            result << Kirpich::MEJ.sample
          end
        end
      end

      result.join(' ')
    end

    def google_search(text)
      "http://lmgtfy.com/?q=#{URI::encode(text)}"
    end

    def pidor_text
      'пидора ответ'
    end

    def cat_image
      "http://www.randomkittengenerator.com/images/cats/rotator.php?#{rand(999999999)}"
    end

    def huifikatorr_text(text)
      url = "http://huifikator.ru/api.php?text=#{text}"
      response = Faraday.get url
      response.body.force_encoding("cp1251").encode("utf-8", undef: :replace)
    rescue
      Kirpich::CALL.sample
    end

    def response_text(text)
      return do_not_know_text unless text

      text = text.split(' ').last
      huifikatorr_text(text)
    end

    def developerslife_image
      response = Faraday.get "http://developerslife.ru/random"
      link = response.headers["location"]

      if link
        response = Faraday.get link
        page = Nokogiri::HTML(response.body)
        image = page.css('.entry .gif img')
        text = page.css('.entry .code .value')

        if image && text
          [image.first["src"], text.first.text.gsub("'",'')]
        end
      end
    end

    def xxx_image(q = 'девушки')
      q += ' голая' if rand(2) == 0
      response = Faraday.get('http://ajax.googleapis.com/ajax/services/search/images', {
        q: "#{q}",
        rsz: '8',
        v: '1.0',
        as_filetype: 'jpg',
        imgsz: 'large',
        start: rand(50)
      })
      result = JSON.parse response.body

      if result.key?("responseData") && result["responseData"].key?("results")
        result["responseData"]["results"].sample["unescapedUrl"]
      else
        NO_GIRLS.sample
      end
    rescue RuntimeError
      NO_GIRLS.sample
    end

    def den_text
      DEN.sample
    end

    def dance_text
      "#{Kirpich::DANCE.sample}?rand=#{rand(999999999)}"
    end

    def random_text
      response = Faraday.get "http://lurkmore.to/%D0%A1%D0%BB%D1%83%D0%B6%D0%B5%D0%B1%D0%BD%D0%B0%D1%8F:Random"

      link = response.headers["location"]
      if link
        response = Faraday.get link
        page = Nokogiri::HTML(response.body)

        images = page.css('img.thumbimage').map { |e| e['src'] }
        if images.any?
          result ||= ''
          result += "#{images.sample.gsub(/^\/\//, 'http://')}\n"
        end

        texts = page.css('#bodyContent>p').map { |e| e.text }

        if texts.any?
          result ||= ''
          result += "#{texts[0]}\n"
          result += "#{texts[1]}\n" if texts.length > 1
        end
      end

      if result && rand(4) == 0
        result += "\nВот так вот, #{Kirpich::APPEAL.sample}"
      end

      result = do_not_know_text unless result

      result
    end

    def brakingmad_text
      response = Faraday.get 'http://breakingmad.me/ru/'

      txts = Nokogiri::HTML(response.body).css(".news-row").map { |e| e }.sample
      txts = "#{txts.css("h2").first.text}.\n\n#{txts.css('.news-full-forspecial').first.text}"
      materialize txts
    end

    def pikabu_image
      response = Faraday.get 'http://pikabu.ru/'
      urls = Nokogiri::HTML(response.body).css(".b-story__content_type_media img").map do |src|
        src['src']
      end
      urls.sample
    end

    def pikabu_text
      response = Faraday.get 'http://pikabu.ru/best'

      txts = Nokogiri::HTML(response.body).css(".b-story__content_type_text").map do |src|
        src.text
      end
      materialize txts.sample
    end

    def interfax_text
      response = Faraday.get 'http://www.interfax.ru/'

      txts = Nokogiri::HTML(response.body).css(".text h3").map do |src|
        src.text
      end

      materialize "#{txts.sample}"
    end

    def currency
      response = Faraday.get "https://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
      result = JSON.parse response.body

      text = result["query"]["results"]["rate"].map do |rate|
        "#{rate["Name"]}: #{rate["Rate"]}"
      end

      text.join("\n")
    end

    def geo_search(q)
      "https://www.google.ru/maps/search/#{q}"
    end

    def chef_text
      Kirpich::GLAV.sample
    end

    def rules_text
      Kirpich::RULES
    end

    def poh_text
      Kirpich::POX.sample
    end

    def do_not_know_text
      Kirpich::HZ.sample
    end

    def appeal_text(text, rand)
      if rand(rand) === 0 && !(text =~ /[,.:;!?'\"\/#$%^&*()]/)
        text + ", #{Kirpich::APPEAL.sample}"
      else
        text
      end
    end

    def hello_text
      text = Kirpich::HELLO.sample
      appeal_text(text, 3)
    end

    def ok_text
      text = Kirpich::ZBS.sample
      appeal_text(text, 2)
    end

    def yes_no_text
      text = YES_NO.sample
      appeal_text(text, 4)
    end

    def sin_text
      text = Kirpich::SIN.sample
      appeal_text(text, 2)
    end

    def nah_text
      text = Kirpich::NAX.sample
      appeal_text(text, 2)
    end

    def call_text
      text = Kirpich::CALL.sample
      appeal_text(text, 4)
    end

    def lurk_search(text)
      return do_not_know_text unless text

      response = Faraday.get "http://lurkmore.to/index.php?title=#{text.strip.gsub(/ /, '_')}"
      md = response.body.scan(/Please.*?\/(.*?)$/im)

      if md && md[0] && md[0][0]
        link = md[0][0]
        response = Faraday.get "http://lurkmore.to/#{link}"
        page = Nokogiri::HTML(response.body)

        images = page.css('img.thumbimage').map { |e| e['src'] }
        if images.any?
          result ||= ''
          result += "#{images.sample.gsub(/^\/\//, 'http://')}\n"
        end

        texts = page.css('#bodyContent>p').map { |e| e.text }

        if texts.any?
          result ||= ''
          result += "#{texts[0]}\n"
          result += "#{texts[1]}\n" if texts.length > 1
        end
      end

      unless result
        if rand(2)
          result = google_search(text)
        else
          result = do_not_know_text
        end
      end

      result
    end
  end
end
