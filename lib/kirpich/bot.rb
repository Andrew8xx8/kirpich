require 'slack'
require 'kirpich/answers'
require 'kirpich/text'
require 'slack'

module Kirpich
  class Bot
    def initialize(config)
      @client = config[:client]
      @answers = config[:answers]
      @fap_count = 0
    end

    def post_text(text, data)
      Slack.chat_postMessage as_user: true, channel: data['channel'], text: text
    rescue RuntimeError
    end

    def can_respond?(data)
      data['subtype'] != 'bot_message' && data['subtype'] != 'message_changed' && data['user'] != 'U081B2XCP' && data.key?('text') && !data['text'].empty?
    end

    def on_message(data)
      return unless can_respond?(data)
      p "Recived: [" + data['text'] + "]"

      result = select_text(data)
      if result
        if (result.is_a?(Array))
          result.each do |part|
            EM.next_tick do
              post_text part, data
            end
          end
        else
          post_text result, data
        end
      end
    end

    def select_text(data)
      text = Kirpich::Text.new(data['text'] || '')

      if text.fap?
        @fap_count += 1
      elsif @fap_count > 0
        @fap_count -= 1
      end

      if @fap_count > 7
        result = @answers.no_fap
        @fap_count = 0
      elsif text.clean =~ /(сред|^(ну и|да и|и) ?похуй)/i
        result = answer(:poh_text)
      elsif text.clean =~ /(зда?о?ров|привет|вечер в хату)/i
        result = answer(:hello_text)
      elsif text.clean =~ /(как дела|что.*?как|чо.*?каво)/i
        result = answer(:news_text)
      elsif text.appeal? || data['channel'] == 'D081AUUHW'
        result = on_call(text, data['channel'])
      end

      result
    end

    def on_call(text, channel)
      if text.clean =~ /(синька)/i
        result = answer(:sin_text)
      elsif text.clean =~ /(пошли|пошел)/i
        result = answer(:nah_text)
      elsif text.clean =~ /^(зда?о?ров|привет)/i
        result = answer(:hello_text)
      elsif text.clean =~ /(танцуй|исполни|пацандобль|танец)/i
        result = answer(:dance_text)
      elsif text.clean =~ /^материализуй.*/i
        result = answer(:materialize, text.clean)
      elsif text.clean =~ /курс/i
        result = answer(:currency)
      elsif text.fap?
        if text.clean =~ /(жопа|задница|попка|попец|булки|ноги|жопу)/i
          result = answer(:random_ass_image)
        elsif text.clean =~ /(сись|тить|грудь|буфер)/i
          result = answer(:random_boobs_image)
        else
          result = answer(:search_xxx_image, text.clean, false)
        end
      elsif text.clean =~ /(кто.*главный)/i
        result = answer(:chef_text)
      elsif text.clean =~ /(программист|девелопер|программер)/i
        result = answer(:developerslife_image)
      elsif text.clean =~ /(картинку|смехуечек|пикчу)/i
        result = answer(:pikabu_image)
      elsif text.clean =~ /(покажи|как выглядит|фотограф|фотку|фотка|изображение)/i
        result = answer(:search_image, text.clean, false)
      elsif text.clean =~ /(посоветуй|дай совет|как надо|как жить|как быть|как стать)/i
        result = answer(:fga_random)
      elsif text.clean =~ /(лох|черт|пидо?р|гей|хуйло|сука|бля|петух|уебок)/i
        result = answer(:nah_text)
      elsif text.clean =~ /(пятница)/i
        result = answer(:brakingmad_text)
      elsif text.clean =~ /где это/i
        m = text.clean.scan(/где это (.*)/im)
        q = m[0][0]
        result = answer(:geo_search, q)
      elsif text.clean =~ /(умеешь|можешь)/i
        result = Kirpich::HELP
      elsif text.clean =~ /(запость|ебни|ебаш|хуяч|хуйни|пиздани|ебани|постани|постни|создай.*настроение|делай красиво|скажи.*что.*нибудь|удиви)/i
        result = random_post
      elsif text.clean =~ /кто.*(охуел|заебал|доебал|надоел|должен|молодец|красавчик)/i
        result = @answers.random_user(channel)
      elsif text.clean =~ /(спасибо|збсь?|красава|молодчик|красавчик|от души|по красоте|зацени|норм)/i
        result = answer(:ok_text)
      elsif text.clean =~ /(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/i
        m = text.clean.scan(/(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/im)
        if m && m[0] && m[0][3]
          q = m[0][3]
          result = answer(:lurk_search, q)
        else
          result = answer(:do_not_know_text)
        end
      elsif text.clean =~ /(еще|повтори|заново|постарайся)/i
        result = last_answer
      elsif text.clean =~ /(нежность|забота|добр(ота)?|милым|заботливым|нежным|добрым)/i
        result = answer(:cat_image)
      elsif text.clean =~ /(правила)/i
        result = answer(:rules_text)
      elsif text.clean =~ /(.*?,)?(.*?)\sили\s(.*?)$/i
        options_match = text.clean.scan(/(.*?,)?(.*?)\sили\s(.*?)$/)
        result = if options_match.any?
                   options = options_match.first.compact.map { |t| t.gsub(/[?. ,]/, '') }
                   answer(:choose_text, options)
                 else
                   HZ.sample
                 end
      elsif text.clean =~ /(погода)/i
        result = answer(:poh_text)
      elsif text.clean =~ /(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i
        md = text.clean.scan(/.*?(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i)
        if md && md[0] && md[0][1]
          result = answer(:google_search, md[0][1])
        end
      elsif text.clean =~ /(ет)$/i
        result = answer(:pidor_text)
      elsif text.clean =~ /.*\?$/i
        result = answer(:choose_text, Kirpich::YES_NO)
      elsif text.clean =~ /выполни.*\(.*?\)/i
        m = text.clean.scan(/выполни.*\((.*)\)/i)
        if m && m[0][0]
          begin
            code = m[0][0].gsub(/(fork|prel|kill|ps|rm|ruby)/, '')
            result = eval(code)
          rescue Exception => e
            p e
            result = answer(:do_not_know_text)
          end
        end
      end

      if rand(5) == 0
        result ||= answer(:response_text, text.clean)
      end

      result || answer(:call_text)
    end

    def random_post
      methods = [:cat_image, :lurk_random, :brakingmad_text, :pikabu_image, :news_text, :currency, :developerslife_image]
      method_object = @answers.method(methods.sample)
      method_object.call
    end

    def random_post_timer
      time = 3000 + rand(6000)

      EM.add_timer(time) do
        data['channel'] = ['C08189F96', 'G084E5SC9'].sample
        post_text(random_post, data)

        random_post_timer
      end
    end

    def answer(method, *args)
      p "Respond with #{method}"
      @last_method = method
      @last_args = args

      method_object = @answers.method(method)
      method_object.call(*args)
    end

    def last_answer
      if @last_method && @last_args
        if @last_method == :search_xxx_image || @last_method == :search_image
          @last_args[1] = true
        end

        method_object = @answers.method(@last_method)
        method_object.call(*@last_args)
      end
    end

    def on_hello
      p "I am ok"
      random_post
      random_post_timer
    end
  end
end
