module Kirpich
  class Answers
    class << self
      def random_user(_, _, channel)
        user = Kirpich::Providers::SlackUser.random(channel)

        return unless user

        name = user['real_name']
        name = user['name'] if name.empty?
        appeal_text(name, 4)
      end

      def materialize(_, _, text)
        build_response Kirpich::Providers::TextUtils.materialize(text)
      end

      def google_search(_, _, text)
        build_response "http://lmgtfy.com/?q=#{URI.encode(text)}"
      end

      def na_text(_, _)
        build_response('хуй на') if rand(2) == 0
      end

      def pidor_text(_, _)
        build_response('пидора ответ') if rand(2) == 0
      end

      def cat_image(_, _)
        build_response("http://www.randomkittengenerator.com/images/cats/rotator.php?#{Time.now.to_i}")
      end

      def developerslife_image(_, _)
        build_response(Kirpich::Providers::Image.developerslife_image)
      end

      def search_image(_, state, q)
        page = 0
        if state[:last_search] && state[:last_search][:q] == q
          page = state[:last_search][:page] + 1
        end
        p state, q, page

        img = Kirpich::Providers::GoogleImage.search(q, page)
        body = img || Kirpich::Dict::NO_GIRLS.sample

        build_response(body, last_search: { page: page, q: q })
      end

      def choose_text(_, _, options)
        text = options.sample
        appeal_text(text, 4)
      end

      def dance_text(_, _)
        build_response("#{Kirpich::Dict::DANCE.sample}?#{Time.now.to_i}")
      end

      def news_text(_, _)
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

      def currency(_, state)
        rates = Kirpich::Providers::Currency.usd_rub_eur_rub
        pc = state[:pc] || {}

        text = rates.map do |currency|
          dynamic = ''
          name = currency[:name]
          rate = currency[:rate]
          if pc.key?(name)
            if rate > pc[name]
              dynamic = "(#{currency_diff(rate, pc[name])} :chart_with_upwards_trend:)"
            elsif rate < pc[name]
              dynamic = "(#{currency_diff(rate, pc[name])} :chart_with_downwards_trend:)"
            end
          end
          pc[name] = rate

          "#{rate} #{currency[:emoji]} #{dynamic}"
        end.join("\n")

        build_response(text, pc: pc)
      end

      def geo_search(_, _, q)
        build_response("https://www.google.ru/maps/search/#{q}")
      end

      def chef_text(_, _)
        build_response(Kirpich::Dict::GLAV.sample)
      end

      def rules_text(_, _)
        build_response(Kirpich::Dict::RULES)
      end

      def poh_text(_, _)
        text = Kirpich::Dict::POX.sample
        appeal_text(text, 4)
      end

      def kak_dela_text(_, _)
        text = Kirpich::Dict::KAK_DELA.sample
        appeal_text(text, 4)
      end

      def do_not_know_text(_, _)
        text = Kirpich::Dict::HZ.sample
        appeal_text(text, 4)
      end

      def appeal_text(text, r = 0)
        if rand(r) == 1 && !(text =~ %r{[,.:;!?'\"\/#$%^&*()]})
          text + ", #{Kirpich::Dict::APPEAL.sample}"
        end

        build_response(text)
      end

      def hello_text(_, _)
        text = Kirpich::Dict::HELLO.sample
        appeal_text(text, 3)
      end

      def ok_text(_, _)
        text = Kirpich::Dict::ZBS.sample
        appeal_text(text, 2)
      end

      def sin_text(_, _)
        text = Kirpich::Dict::SIN.sample
        appeal_text(text, 2)
      end

      def nah_text(_, _)
        text = Kirpich::Dict::NAX.sample
        appeal_text(text, 2)
      end

      def call_text(_, _)
        text = Kirpich::Dict::CALL.sample
        appeal_text(text, 4)
      end

      def lurk_search(_, _, text)
        result = Kirpich::Providers::Lurk.search(text)

        if result.empty?
          do_not_know_text(_, _)
        else
          build_response(result)
        end
      end

      def fga_random(_, _)
        build_response(Kirpich::Providers::Fga.random)
      end

      def lurk_random(_, _)
        build_response(Kirpich::Providers::Lurk.random)
      end

      def random_ass_image(_, _)
        build_response(Kirpich::Providers::Image.les_400_image)
      rescue => e
        Kirpich.logger.error e
        build_response(Kirpich::Dict::NO_GIRLS.sample)
      end

      def random_boobs_image(_, _)
        build_response(Kirpich::Providers::Image.lesaintdesseins_image)
      end

      def build_response(body, state = {})
        Kirpich::Response.new(body: body, state: state)
      end
    end
  end
end
