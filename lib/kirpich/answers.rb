module Kirpich
  class Answers
    class << self
      def about(_, _)
        build_response Kirpich::Dict::ABOUT
      end

      def slots_rules(_, _)
        build_response Kirpich::Dict::SPIN + Kirpich::Providers::Slots.wintable
      end

      def spin(request, state, line_index, rate)
        slots = state[:slots] || {}
        score = slots[request.user] || 100
        text, new_score = Kirpich::Providers::Slots.spin(score, line_index, rate)
        build_response(text, state.merge(slots: slots.merge({ request.user => new_score })))
      end

      def random_user(r, s, channel)
        user = Kirpich::Providers::SlackUser.random(channel)

        return unless user

        name = user['real_name']
        name = user['name'] if name.empty?
        appeal_text(r, s, name, 4)
      end

      def materialize(_, _, text)
        build_response Kirpich::Providers::TextUtils.materialize(text)
      end

      def google_search(_, _, text)
        build_response "http://lmgtfy.com/?q=#{URI.encode(text)}"
      end

      def a_or_b_text(_, _, a, b, r)
        text = if rand(r) == 0
                 a.sample
               else
                 b.sample
               end

        build_response(text)
      end

      def text(_, _, text, rand = 2)
        build_response(text) if rand(rand) == 0
      end

      def cat_image(_, _)
        build_response("http://www.randomkittengenerator.com/images/cats/rotator.php?#{Time.now.to_i}")
      end

      def developerslife_image(_, _)
        build_response(Kirpich::Providers::Image.developerslife_image)
      end

      def devopsreactions_image(_, _)
        build_response(Kirpich::Providers::Image.devopsreactions_image)
      end

      def search_image(_, state, q)
        page = 1
        if state[:last_search] && state[:last_search][:q] == q
          page = state[:last_search][:page] + 1
        end

        Kirpich.logger.info("image_search_provider is [#{image_search_provider}]")

        img = image_search_provider.search(q, page)
        body = img || Kirpich::Dict::NO_CONTENT.sample

        build_response(body, last_search: { page: page, q: q })
      end

      def choose_text(r, s, options)
        text = options.sample
        appeal_text(r, s, text, 4)
      end

      def dance_text(_, _)
        build_response("#{Kirpich::Dict::DANCE.sample}?#{Time.now.to_i}")
      end

      def news_text(r, s)
        text = if rand(2) == 0
                 Kirpich::Providers::Text.interfax
               else
                 Kirpich::Providers::Text.ria
               end
        materialize r, s, text
      end

      def currency_diff(a, b)
        format('%.4f', a.to_f - b.to_f)
      end

      def currency(_, state)
        rates = Kirpich::Providers::Currency.usd_rub_eur_rub_btc
        pc = state[:pc] || {}

        text = rates.map do |currency|
          dynamic = ''
          name = currency[:name]
          rate = currency[:rate]
          if pc.key?(name)
            if rate > pc[name]
              dynamic = "(#{currency_diff(rate, pc[name])} 📈)"
            elsif rate < pc[name]
              dynamic = "(#{currency_diff(rate, pc[name])} 📉)"
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

      def aphorism(_, _)
        aphorism = Kirpich::Providers::Ololo.aphorism
        build_response(aphorism)
      end

      def random_phrase(_, _)
        phrase = Kirpich::Dict::RANDOM.sample
        build_response(phrase)
      end

      def rules_text(_, _)
        build_response(Kirpich::Dict::RULES)
      end

      def appeal_text(_, _, text, r = 0)
        if rand(r) == 1 && !(text =~ %r{[,.:;!?'\"\/#$%^&*()]})
          text + ", #{Kirpich::Dict::APPEAL.sample}"
        end

        build_response(text)
      end

      def lurk_search(request, state, text)
        result = Kirpich::Providers::Lurk.search(text)

        if result.empty?
          appeal_text(request, state, Kirpich::Dict::HZ.sample, 2)
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

      def gusar_image(_, _, from = 0.4, to = 0.5, boobs = false, butt = false)
        build_response(Kirpich::Providers::Image.gusar_image(from, to, boobs, butt))
      rescue => e
        Kirpich.logger.error e
        build_response(Kirpich::Dict::NO_CONTENT.sample)
      end

      def build_response(body, state = {})
        Kirpich::Response.new(body: body, state: state)
      end

      private

      def image_search_provider
        @image_search_provider ||= if Kirpich::Providers::GoogleImageCustomSearch.configured?
          Kirpich::Providers::GoogleImageCustomSearch
        end
      end
    end
  end
end
