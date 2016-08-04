module Kirpich
  class Brain
    class << self
      def respond_on(request)
        Kirpich.logger.info request.to_s

        text = Kirpich::Text.new(request.text || '')

        if text.clean =~ /(^|\s)я($|\.|\?)/i
          Kirpich::Answer.new(:text, Kirpich::Dict::I.sample)
        elsif text.clean =~ /(^|\s)да($|\.|\?)/i
          Kirpich::Answer.new(:a_or_b_text, Kirpich::Dict::YES, Kirpich::Dict::YES_NO, 6)
        elsif text.clean =~ /(^|\s)нет($|\.|\?)/i
          Kirpich::Answer.new(:a_or_b_text, Kirpich::Dict::PID, Kirpich::Dict::YES_NO, 6)
        elsif text.clean =~ /\b(среда|^(ну и|да и|и) ?похуй)\b/i
          Kirpich::Answer.new(:appeal_text, Kirpich::Dict::POX.sample, 2)
        elsif text.clean =~ /\b(зда?о?ров|привет|вечер в хату)\b/i
          Kirpich::Answer.new(:appeal_text, Kirpich::Dict::HELLO.sample, 3)
        elsif text.clean =~ /(что.*?как|ч(о|е|ё).*?каво)/i
          Kirpich::Answer.new(:news_text)
        elsif text.appeal? || request.channel == 'D081AUUHW'
          on_call(text, request.channel)
        end
      end

      def on_call(text, channel)
        if text.clean =~ /что.*?(надо|нужно|стоит).*?(делать|сделать).*если.*(не нравит|заебал|надоел|не устраивает)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::SVCHAT, 10)
        elsif text.clean =~ /\bкак дела\b/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::KAK_DELA.sample, 4)
        elsif text.clean =~ /(расскажи о себе|ты кто)/i
          answer = Kirpich::Answer.new(:about)
        elsif text.clean =~ /(синька)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::SIN.sample, 1)
        elsif text.clean =~ /(быстра|пошел ты|в жопу раз|вилкой в глаз|тебе в жопу)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::NAX.sample, 2)
        elsif text.clean =~ /\b(танцуй|исполни|пацандобль|танец)\b/i
          answer = Kirpich::Answer.new(:dance_text)
        elsif text.clean =~ /^материализуй.*/i
          answer = Kirpich::Answer.new(:materialize, text.clean)
        elsif text.clean =~ /курс/i
          answer = Kirpich::Answer.new(:currency)
        elsif text.fap?
          if text.clean =~ /\b(жопа|задница|попка|попец|булки|ноги|жопу)\b/i
            answer = Kirpich::Answer.new(:random_ass_image)
          elsif text.clean =~ /\b(соски|сися|сись|тить|грудь|буфер|груди)/i
            answer = Kirpich::Answer.new(:random_boobs_image)
          else
            answer = Kirpich::Answer.new(:search_image, text.clean)
          end
        elsif text.clean =~ /(кто.*главный)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::GLAV.sample, 2)
        elsif text.clean =~ /\b(программист|девелопер|программер)(?:ов)?\b/i
          answer = Kirpich::Answer.new(:developerslife_image)
        elsif text.clean =~ /\bадмин(?:ов|ах)?\b/i
          answer = Kirpich::Answer.new(:devopsreactions_image)
        elsif text.clean =~ /(видео|видос)/i
          answer = Kirpich::Answer.new(:search_video, text.clean)
        elsif text.clean =~ /(покажи|как выглядит|фотограф|фотку|фотка|изображение)/i
          answer = Kirpich::Answer.new(:search_image, text.clean)
        elsif text.clean =~ /(посоветуй|дай совет|как надо|как жить|как быть|как стать)/i
          answer = Kirpich::Answer.new(:fga_random)
        elsif text.clean =~ /кто.*(охуел|заебал|доебал|надоел|должен|молодец|красавчик)/i
          answer = Kirpich::Answer.new(:random_user, channel)
        elsif text.clean =~ /(лох|черт|пидо?р|гей|хуйло|сука|бля|петух|уебок|заебал)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::NAX.sample, 0)
        elsif text.clean =~ /где это/i
          m = text.clean.scan(/где это (.*)/im)
          if m && m[0] && m[0][0]
            q = m[0][0]
            answer = Kirpich::Answer.new(:geo_search, q)
          end
        elsif text.clean =~ /(умеешь|можешь)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::HELP, 0)
        elsif text.clean =~ /(запость|ебни|ебаш|хуяч|хуйни|пиздани|ебани|постани|постни|создай.*настроение|делай красиво|скажи.*что.*нибудь|удиви)/i
          answer = random_response
        elsif text.clean =~ /(спасибо|збсь?|красава|молодчик|красавчик|от души|по красоте|зацени|норм)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::ZBS.sample, 2)
        elsif text.clean =~ /(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/i
          m = text.clean.scan(/(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/im)
          if m && m[0] && m[0][3]
            q = m[0][3]
            answer = Kirpich::Answer.new(:lurk_search, q)
          else
            answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::HZ.sample, 2)
          end
        elsif text.clean =~ /(еще|повтори|заново|постарайся|продолжай)/i
          answer = Kirpich::Answer.new(:last_answer)
        elsif text.clean =~ /(нежность|забота|добр(ота)?|милым|заботливым|нежным|добрым)/i
          answer = Kirpich::Answer.new(:cat_image)
        elsif text.clean =~ /(правила)/i
          answer = Kirpich::Answer.new(:rules_text)
        elsif text.clean =~ /афоризмы?/i
          answer = Kirpich::Answer.new(:aphorism)
        elsif text.clean =~ /(.*?,)?(.*?)\sили\s(.*?)$/i
          options_match = text.clean.scan(/(.*?,)?(.*?)\sили\s(.*?)$/)
          answer = if options_match.any?
                     options = options_match.first.compact.map { |t| t.gsub(/[?. ,]/, '') }
                     Kirpich::Answer.new(:choose_text, options)
                   else
                     HZ.sample
                   end
        elsif text.clean =~ /(погода)/i
          answer = Kirpich::Answer.new(:appeal_text, Kirpich::Dict::POX.sample, 3)
        elsif text.clean =~ /(найди|поищи|загугли|погугли|пошурши|че там)\s(.*?)$/i
          md = text.clean.scan(/.*?(найди|поищи|загугли|погугли|пошурши|че там)\s(.*?)$/i)
          answer = Kirpich::Answer.new(:google_search, md[0][1]) if md && md[0] && md[0][1]
        elsif text.clean =~ /.*\?$/i
          answer = Kirpich::Answer.new(:choose_text, Kirpich::Dict::YES_NO)
        end

        answer || Kirpich::Answer.new(:appeal_text, Kirpich::Dict::CALL.sample, 3)
      end

      def random_response
        methods = [
          :random_boobs_image, :random_ass_image, :currency, :developerslife_image,
          :fga_random, :news_text, :random_phrase, :lurk_random
        ]

        Kirpich::Answer.new(methods.sample)
      end
    end
  end
end
