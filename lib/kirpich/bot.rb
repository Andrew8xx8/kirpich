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
      return if data['user'] == 'U081B2XCP'

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
          text = @answers.poh_text
        elsif data['text'] =~ /(зда?о?ров|привет|вечер в хату)/i
          text = @answers.hello_text
        elsif data['text'] =~ /(как дела|что.*?как|чо.*?каво)/i
          if rand(2) == 0
            text = @answers.developerslife_image
          else
            text = @answers.interfax_text
          end
        elsif data['text'] =~ /^(паштет|пашок|пашка|кирпич|паш|пацантре|народ|кто-нибудь|эй|э)/i || data['text'] =~ /(kirpich:|@kirpich:)/ || data['channel'] == 'D081AUUHW'
          text = on_call(data)
        end
      rescue RuntimeError
        text = @answers.do_not_know_text
      end

      text
    end

    def on_call(data)
      if data['text'] =~ /(синька)/i
        text = @answers.sin_text
      elsif data['text'] =~ /(пошли|пошел)/i
        text = @answers.nah_text
      elsif data['text'] =~ /(лох|черт|пидо?р|гей|хуйло|сука|бля|петух)/i
        text = @answers.nah_text
      elsif data['text'] =~ /^(зда?о?ров|привет)/i
        text = @answers.hello_text
      elsif data['text'] =~ /(спасибо|збсь?|красава|молодчик|красавчик|от души|по красоте|зацени)/i
        text = @answers.ok_text
      elsif data['text'] =~ /(танцуй|исполни|пацандобль|танец)/i
        text = @answers.dance_text
      elsif data['text'] =~ /^материализуй.*/i
        text = @answers.materialize(data['text'])
      elsif data['text'] =~ /(титьк|грудь|сисек|сиська|сиськи|сиську|сосок|понедельник)/i
        text = @answers.sexcom_image('http://www.sex.com/babes+big-tits/porn-pics/?sort=latest')
      elsif data['text'] =~ /(жоп|задниц|попец|вторник)/i
        text = @answers.sexcom_image('http://www.sex.com/ass+babes/porn-pics/?sort=latest')
      elsif data['text'] =~ /(рыжая|рыжую)/i
        text = @answers.sexcom_image('http://www.sex.com/babes+redhead/porn-pics/?sort=latest')
      elsif data['text'] =~ /(винтаж|олдскул|ламповую)/i
        text = @answers.sexcom_image('http://www.sex.com/babes+vintage/porn-pics/?sort=latest')
      elsif data['text'] =~ /(блондин|белую)/i
        text = @answers.sexcom_image('http://www.sex.com/babes+blonde/porn-pics/?sort=latest')
      elsif data['text'] =~ /(броюнет)/i
        text = @answers.sexcom_image('http://www.sex.com/babes+brunette/porn-pics/?sort=latest')
      elsif data['text'] =~ /(кто.*главный)/i
        text = @answers.chef_text
      elsif data['text'] =~ /(программист|девелопер)/i
        text = @answers.developerslife_image
      elsif data['text'] =~ /(картинку|смехуечек|пикчу)/i
        text = @answers.pikabu_image
      elsif data['text'] =~ /(пятница)/i
        text = @answers.brakingmad_text
      elsif data['text'] =~ /где это/i
        m = data['text'].scan(/где это (.*)/im)
        q = m[0][0]
        text = @answers.geo_search(q)
      elsif data['text'] =~ /курс/i
        text = @answers.currency
      elsif data['text'] =~ /(умеешь|можешь)/i
        text = Kirpich::HELP
      elsif data['text'] =~ /(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/i
        m = data['text'].scan(/(объясни|разъясни|растолкуй|что|как|кто) ?(что|как|кто)? ?(это|эта|такой|такое|такие)? (.*)/im)
        if m && m[0] && m[0][3]
          q = m[0][3]
          text = @answers.lurk_search q
        else
          text = @answers.do_not_know_text
        end
      elsif data['text'] =~ /(запость|ебни|пиздани|ебани|постани|постни).*(сереге)/i
        text = @answers.sexcom_image('http://www.sex.com/big-dicks/porn-pics/?sort=latest')
      elsif data['text'] =~ /(денчик)/i
        text = @answers.den_text
      elsif data['text'] =~ /(запость|ебни|пиздани|ебани|постани|постни|еще|создай.*настроение|скажи.*что.*нибудь)/i
        text = @answers.random_text
      elsif data['text'] =~ /(нежность|забота|добр(ота)?|милым|заботливым|нежным|добрым)/i
        text = @answers.cat_image
      elsif data['text'] =~ /(правила)/i
        text = @answers.rules_text
      elsif data['text'] =~ /(погода)/i
        text = @answers.poh_text
      elsif data['text'] =~ /(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i
        md = data['text'].scan(/.*?(найди|поищи|загугли|погугли|по шурши|че там)\s(.*?)$/i)
        if md && md[0] && md[0][1]
          text = @answers.google_search(md[0][1])
        end
      elsif data['text'] =~ /(нет)$/i
        text = @answers.pidor_text
      elsif data['text'] =~ /выполни.*\(.*?\)/i
        m = data['text'].scan(/выполни.*\((.*)\)/i)
        if m && m[0][0]
          begin
            text = eval(m[0][0])
          rescue Exception => e
            p e
            text = @answers.do_not_know_text
          end
        end
      elsif data['text'] =~ /\?$/i
        text = @answers.yes_no_text(data)
      end

      if rand(2) == 0
        text ||= @answers.response_text(data['text'])
      end

      text ||= @answers.call_text
    end

    def random_post
      methods = [:cat_image, :random_text, :brakingmad_text, :pikabu_image, :pikabu_text, :interfax_text, :currency, :developerslife_image]
      @answers.send methods.sample
    end

    def random_post_timer
      time = 5000 + rand(7000)

      EM.add_timer(time) do
        Slack.chat_postMessage as_user: true, channel: ['C08189F96', 'G084E5SC9'].sample, text: random_post

        random_post_timer
      end
    end

    def on_hello
      p "I am ok"
      random_post
      random_post_timer
    end
  end
end
