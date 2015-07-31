require 'slack'
require 'kirpich/answers'

module Kirpich
  class Bot
    def initialize(config)
      @client = config[:client]
      @answers = config[:answers]
    end

    def post_text(text, data)
      Slack.chat_postMessage as_user: true, channel: data['channel'], text: text
    rescue RuntimeError
    end

    def on_message(data)
      return if data['user'] == 'U081B2XCP' || data['subtype'] == 'message_changed'

      text = select_text(data)
      if text
        if (text.is_a?(Array))
          text.each do |part|
            EM.next_tick do
              post_text part, data
            end
          end
        else
          post_text text, data
        end
      end
    end

    def select_text(data)
      text = ''

      begin
        if data['text'] =~ /(сред|^(ну и|да и|и) ?похуй)/i
          text = answer(:poh_text)
        elsif data['text'] =~ /(зда?о?ров|привет|вечер в хату)/i
          text = answer(:hello_text)
        elsif data['text'] =~ /(как дела|что.*?как|чо.*?каво)/i
          text = answer(:interfax_text)
        elsif data['text'] =~ /^(паштет|пашок|пашка|кирпич|паш|пацантре|народ|кто-нибудь|эй|э)/i || data['text'] =~ /(kirpich:|@kirpich:)/ || data['channel'] == 'D081AUUHW'
          text = on_call(data)
        end
      rescue RuntimeError => e
        p e
        text = answer(:do_not_know_text)
      end

      text
    end

    def on_call(data)
      p "." + data['text'] + "."
      if data['text'] =~ /(синька)/i
        text = answer(:sin_text)
      elsif data['text'] =~ /.*\?$/i
        text = answer(:yes_no_text, data)
      elsif data['text'] =~ /(пошли|пошел)/i
        text = answer(:nah_text)
      elsif data['text'] =~ /(лох|черт|пидо?р|гей|хуйло|сука|бля|петух)/i
        text = answer(:nah_text)
      elsif data['text'] =~ /^(зда?о?ров|привет)/i
        text = answer(:hello_text)
      elsif data['text'] =~ /(спасибо|збсь?|красава|молодчик|красавчик|от души|по красоте|зацени)/i
        text = answer(:ok_text)
      elsif data['text'] =~ /(танцуй|исполни|пацандобль|танец)/i
        text = answer(:dance_text)
      elsif data['text'] =~ /^материализуй.*/i
        text = answer(:materialize, data['text'])
      elsif data['text'] =~ /(титьк|грудь|сисек|сиська|сиськи|сиську|сосок|понедельник)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(жоп|задниц|попец|вторник)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(рыжая|рыжую)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(винтаж|олдскул|ламповую)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(блондин|белую)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(броюнет)/i
        text = answer(:girlstream_image)
      elsif data['text'] =~ /(кто.*главный)/i
        text = answer(:chef_text)
      elsif data['text'] =~ /(программист|девелопер|гиф)/i
        text = answer(:developerslife_image)
      elsif data['text'] =~ /(картинку|смехуечек|пикчу)/i
        text = answer(:pikabu_image)
      elsif data['text'] =~ /(пятница)/i
        text = answer(:brakingmad_text)
      elsif data['text'] =~ /где это/i
        m = data['text'].scan(/где это (.*)/im)
        q = m[0][0]
        text = answer(:geo_search, q)
      elsif data['text'] =~ /курс/i
        text = answer(:currency)
      elsif data['text'] =~ /(умеешь|можешь)/i
        text = Kirpich::HELP
      elsif data['text'] =~ /(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/i
        m = data['text'].scan(/(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/im)
        if m && m[0] && m[0][3]
          q = m[0][3]
          text = answer(:lurk_search, q)
        else
          text = answer(:do_not_know_text)
        end
      elsif data['text'] =~ /(еще|повтори|заново|постарайся)/i
        text = last_answer
      elsif data['text'] =~ /(запость|ебни|ебаш|хуяч|хуйни|пиздани|ебани|постани|постни|создай.*настроение|скажи.*что.*нибудь)/i
        text = random_post
      elsif data['text'] =~ /(нежность|забота|добр(ота)?|милым|заботливым|нежным|добрым)/i
        text = answer(:cat_image)
      elsif data['text'] =~ /(правила)/i
        text = answer(:rules_text)
      elsif data['text'] =~ /(погода)/i
        text = answer(:poh_text)
      elsif data['text'] =~ /(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i
        md = data['text'].scan(/.*?(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i)
        if md && md[0] && md[0][1]
          text = answer(:google_search, md[0][1])
        end
      elsif data['text'] =~ /(нет)$/i
        text = answer(:pidor_text)
      elsif data['text'] =~ /выполни.*\(.*?\)/i
        m = data['text'].scan(/выполни.*\((.*)\)/i)
        if m && m[0][0]
          begin
            text = eval(m[0][0])
          rescue Exception => e
            p e
            text = answer(:do_not_know_text)
          end
        end
      end

      if rand(2) == 0
        text ||= answer(:response_text, data['text'])
      end

      text ||= answer(:call_text)
    end

    def random_post
      methods = [:cat_image, :random_text, :brakingmad_text, :pikabu_image, :pikabu_text, :interfax_text, :currency, :developerslife_image]
      answer(methods.sample)
    end

    def random_post_timer
      time = 5000 + rand(7000)

      EM.add_timer(time) do
        Slack.chat_postMessage as_user: true, channel: ['C08189F96', 'G084E5SC9'].sample, text: random_post

        random_post_timer
      end
    end

    def answer(method, *args)
      @last_method = method
      @last_args = args
      method_object = @answers.method(method)
      method_object.call(*args)
    end

    def last_answer
      if @last_method && @last_args
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
