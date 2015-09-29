module Kirpich
  class Answers
    def initialize
      @prev_currency = {}
    end

    def random_user(channel)
      user = Kirpich::Providers::SlackUser.random(channel)

      if user
        name = user['real_name']
        name = user['name'] if name.empty?
        appeal_text(name, 0)
      end
    end

    def no_fap
      Kirpich::Dict::NO_FAP.sample
    end

    def materialize(text)
      result = []
      text.split(' ').each do |word|
        if word != 'материализуй'
          result << word

          if word.size > 3 && !(word =~ /[,.:;!?'\"\/#$%^&*()]/) && rand(7) == 5
            result << Kirpich::Dict::MEJ.sample
          end
        end
      end

      result.join(' ')
    end

    def google_search(text)
      "http://lmgtfy.com/?q=#{URI.encode(text)}"
    end

    def pidor_text
      'да' if rand(2)
    end

    def pidor_text
      'пидора ответ' if rand(2)
    end

    def cat_image
      "http://www.randomkittengenerator.com/images/cats/rotator.php?#{Time.now.to_i}"
    end

    def huifikatorr_text(text)
      url = "http://huifikator.ru/api.php?text=#{text}"
      response = Faraday.get url
      response.body.force_encoding('cp1251').encode('utf-8', undef: :replace)
    rescue
      Kirpich::Dict::CALL.sample
    end

    def response_text(text)
      return do_not_know_text unless text

      text = text.split(' ').last
      huifikatorr_text(text)
    end

    def les_400_image
      Kirpich::Providers::Image.les_400_image
    end

    def developerslife_image
      response = Faraday.get 'http://developerslife.ru/random'
      link = response.headers['location']

      if link
        response = Faraday.get link
        page = Nokogiri::HTML(response.body)
        image = page.css('.entry .gif img')
        text = page.css('.entry .code .value')

        [image.first['src'], text.first.text.delete("'")] if image && text
      end
    end

    def search_image(q, random)
      img = Kirpich::Providers::GoogleImage.search(q, random)
      img || Kirpich::Dict::NO_GIRLS.sample
    end

    def search_xxx_image(q, random)
      img = Kirpich::Providers::GoogleImage.search_xxx(q, random)
      img || Kirpich::Dict::NO_GIRLS.sample
    end

    def choose_text(options)
      text = options.sample
      appeal_text(text, 4)
    end

    def den_text
      DEN.sample
    end

    def dance_text
      "#{Kirpich::Dict::DANCE.sample}?#{Time.now.to_i}"
    end

    def brakingmad_text
      response = Faraday.get 'http://breakingmad.me/ru/'

      txts = Nokogiri::HTML(response.body).css('.news-row').map { |e| e }.sample
      txts = "#{txts.css('h2').first.text}.\n\n#{txts.css('.news-full-forspecial').first.text}"
      materialize txts
    end

    def pikabu_image
      response = Faraday.get 'http://pikabu.ru/'
      urls = Nokogiri::HTML(response.body).css('.b-story__content_type_media img').map do |src|
        src['src']
      end
      urls.sample
    end

    def news_text
      text = if rand(2) == 0
               Kirpich::Providers::Text.interfax
             else
               Kirpich::Providers::Text.ria
             end
      materialize text
    end

    def currency_diff(a, b)
      format('%.4f', a.to_f - b.to_f)
    end

    def currency
      response = Faraday.get 'https://query.yahooapis.com/v1/public/yql?q=select+*+from+yahoo.finance.xchange+where+pair+=+%22USDRUB,EURRUB%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback='
      result = JSON.parse response.body

      text = result['query']['results']['rate'].map do |rate|
        name = rate['Name']
        rate = rate['Rate']
        name_emoji = if name =~ /USD/
                       ':dollar:'
                     else
                       ':euro:'
                     end
        dynamic = ''

        if @prev_currency[name]
          if rate > @prev_currency[name]
            dynamic = "(#{currency_diff(rate, @prev_currency[name])} :chart_with_upwards_trend:)"
          elsif rate < @prev_currency[name]
            dynamic = "(#{currency_diff(rate, @prev_currency[name])} :chart_with_downwards_trend:)"
          end
        end
        @prev_currency[name] = rate

        "#{rate} #{name_emoji} #{dynamic}"
      end

      text.join("\n")
    end

    def geo_search(q)
      "https://www.google.ru/maps/search/#{q}"
    end

    def chef_text
      Kirpich::Dict::GLAV.sample
    end

    def rules_text
      Kirpich::Dict::RULES
    end

    def poh_text
      Kirpich::Dict::POX.sample
    end

    def do_not_know_text
      Kirpich::Dict::HZ.sample
    end

    def appeal_text(text, r)
      if rand(r) === 0 && !(text =~ /[,.:;!?'\"\/#$%^&*()]/) || r === 0
        text + ", #{Kirpich::Dict::APPEAL.sample}"
      else
        text
      end
    end

    def hello_text
      text = Kirpich::Dict::HELLO.sample
      appeal_text(text, 3)
    end

    def ok_text
      text = Kirpich::Dict::ZBS.sample
      appeal_text(text, 2)
    end

    def sin_text
      text = Kirpich::Dict::SIN.sample
      appeal_text(text, 2)
    end

    def nah_text
      text = Kirpich::Dict::NAX.sample
      appeal_text(text, 2)
    end

    def call_text
      text = Kirpich::Dict::CALL.sample
      appeal_text(text, 4)
    end

    def lurk_search(text)
      result = Kirpich::Dict::Providers::Lurk.search(text)

      if result.empty?
        do_not_know_text
      else
        result
      end
    end

    def fga_random
      Kirpich::Providers::Fga.random
    end

    def lurk_random
      Kirpich::Providers::Lurk.random
    end

    def random_ass_image
      Kirpich::Providers::Image.les_400_image
    rescue => e
      Kirpich.logger.error e
      Kirpich::Dict::NO_GIRLS.sample
    end

    def random_boobs_image
      Kirpich::Providers::Image.lesaintdesseins_image
    end
  end
end
