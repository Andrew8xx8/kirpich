module Kirpich
  class Client
    def post(text, request)
      EM.next_tick do
        Slack.chat_postMessage as_user: true, channel: request.channel, text: text
      end
    rescue RuntimeError => e
      Kirpich.logger.error e
    end

    def post_after(time)
      EM.add_timer(time) do
        yield
      end
    end
  end
end
