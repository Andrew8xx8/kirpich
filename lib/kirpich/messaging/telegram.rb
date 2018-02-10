module Kirpich::Messaging
  class Telegram
    include Virtus.model

    attribute :token, String

    def start
      Kirpich.logger.info "Starting Telegram service"

      ::Telegram::Bot::Client.run(token) do |tbot|
        on_post = -> (request, text) {
          post(tbot, request, text)
        }
        @bot = Kirpich::Bot.new(on_post: on_post)

        tbot.listen do |message|
          ap message
          on_message(message)
        end
      end
    end

    def post(tbot, request, text)
      tbot.api.send_message(chat_id: request.channel, text: text)
    rescue RuntimeError => e
      Kirpich.logger.error e
    end

    def on_message(data)
      request = Kirpich::Messaging::Telegram::Request.new(data)
      @bot.on_message(request)
    end

  end
end
