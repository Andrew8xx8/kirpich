module Kirpich
  class Brain
    class << self
      def respond_on(request)
        Kirpich.logger.info request.to_s

        text = Kirpich::Text.new(request.text || '')

        if text.clean =~ /(сред|^(ну и|да и|и) ?похуй)/i
          Kirpich::Answer.new(:poh_text)
        elsif text.clean =~ /(зда?о?ров|привет|вечер в хату)/i
          Kirpich::Answer.new(:hello_text)
        elsif text.clean =~ /(что.*?как|чо.*?каво)/i
          Kirpich::Answer.new(:news_text)
        elsif text.clean =~ /как дела/i
          Kirpich::Answer.new(:kak_dela_text)
        elsif text.appeal? || request.channel == 'D081AUUHW'
          on_call(text, request.channel)
        end
      end

      def on_call(text, channel)
        if text.clean =~ /(синька)/i
          answer = Kirpich::Answer.new(:sin_text)
        elsif text.clean =~ /(быстра|пошел ты|в жопу раз|вилкой в глаз|тебе в жопу)/i
          answer = Kirpich::Answer.new(:nah_text)
        elsif text.clean =~ /^(зда?о?ров|привет)/i
          answer = Kirpich::Answer.new(:hello_text)
        elsif text.clean =~ /(танцуй|исполни|пацандобль|танец)/i
          answer = Kirpich::Answer.new(:dance_text)
        elsif text.clean =~ /^материализуй.*/i
          answer = Kirpich::Answer.new(:materialize, text.clean)
        elsif text.clean =~ /курс/i
          answer = Kirpich::Answer.new(:currency)
        elsif text.fap?
          if text.clean =~ /(жопа|задница|попка|попец|булки|ноги|жопу)/i
            answer = Kirpich::Answer.new(:random_ass_image)
          elsif text.clean =~ /(соски|сися|сись|тить|грудь|буфер|груди)/i
            answer = Kirpich::Answer.new(:random_boobs_image)
          else
            answer = Kirpich::Answer.new(:search_image, text.clean)
          end
        elsif text.clean =~ /(кто.*главный)/i
          answer = Kirpich::Answer.new(:chef_text)
        elsif text.clean =~ /(программист|девелопер|программер)/i
          answer = Kirpich::Answer.new(:developerslife_image)
        elsif text.clean =~ /(покажи|как выглядит|фотограф|фотку|фотка|изображение)/i
          answer = Kirpich::Answer.new(:search_image, text.clean)
        elsif text.clean =~ /(посоветуй|дай совет|как надо|как жить|как быть|как стать)/i
          answer = Kirpich::Answer.new(:fga_random)
        elsif text.clean =~ /(лох|черт|пидо?р|гей|хуйло|сука|бля|петух|уебок)/i
          answer = Kirpich::Answer.new(:nah_text)
        elsif text.clean =~ /где это/i
          m = text.clean.scan(/где это (.*)/im)
          q = m[0][0]
          answer = Kirpich::Answer.new(:geo_search, q)
        elsif text.clean =~ /(умеешь|можешь)/i
          answer = Kirpich::HELP
        elsif text.clean =~ /(запость|ебни|ебаш|хуяч|хуйни|пиздани|ебани|постани|постни|создай.*настроение|делай красиво|скажи.*что.*нибудь|удиви)/i
          answer = random_post
        elsif text.clean =~ /кто.*(охуел|заебал|доебал|надоел|должен|молодец|красавчик)/i
          answer = @answers.random_user(channel)
        elsif text.clean =~ /(спасибо|збсь?|красава|молодчик|красавчик|от души|по красоте|зацени|норм)/i
          answer = Kirpich::Answer.new(:ok_text)
        elsif text.clean =~ /(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/i
          m = text.clean.scan(/(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/im)
          if m && m[0] && m[0][3]
            q = m[0][3]
            answer = Kirpich::Answer.new(:lurk_search, q)
          else
            answer = Kirpich::Answer.new(:do_not_know_text)
          end
        elsif text.clean =~ /(еще|повтори|заново|постарайся)/i
          answer = Kirpich::Answer.new(:last_answer)
        elsif text.clean =~ /(нежность|забота|добр(ота)?|милым|заботливым|нежным|добрым)/i
          answer = Kirpich::Answer.new(:cat_image)
        elsif text.clean =~ /(правила)/i
          answer = Kirpich::Answer.new(:rules_text)
        elsif text.clean =~ /(.*?,)?(.*?)\sили\s(.*?)$/i
          options_match = text.clean.scan(/(.*?,)?(.*?)\sили\s(.*?)$/)
          answer = if options_match.any?
                     options = options_match.first.compact.map { |t| t.gsub(/[?. ,]/, '') }
                     Kirpich::Answer.new(:choose_text, options)
                   else
                     HZ.sample
                   end
        elsif text.clean =~ /(погода)/i
          answer = Kirpich::Answer.new(:poh_text)
        elsif text.clean =~ /(найди|поищи|загугли|погугли|пошурши|че там)\s(.*?)$/i
          md = text.clean.scan(/.*?(найди|поищи|загугли|погугли|пошурши|че там)\s(.*?)$/i)
          answer = Kirpich::Answer.new(:google_search, md[0][1]) if md && md[0] && md[0][1]
        elsif text.clean =~ /(ет)$/i
          answer = Kirpich::Answer.new(:pidor_text)
        elsif text.clean =~ /(да)$/i
          answer = Kirpich::Answer.new(:na_text)
        elsif text.clean =~ /.*\?$/i
          if text.clean =~ /да\?$/i && rand(4) == 1
            answer = Kirpich::Answer.new(:na_text)
          else
            answer = Kirpich::Answer.new(:choose_text, Kirpich::Dict::YES_NO)
          end
        end

        answer || Kirpich::Answer.new(:call_text)
      end
    end
  end
end
