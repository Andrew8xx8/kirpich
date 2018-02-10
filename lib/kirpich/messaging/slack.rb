module Kirpich::Messaging
  class Slack

    include Virtus.model

    attribute :token, String
    attribute :auth, Hash
    attribute :bot, Kirpich::Bot

    def start
      Kirpich.logger.info "Starting slack service"

      ::Slack.configure { |config| config.token = token }
      @auth = ::Slack.auth_test
      raise_auth_error unless @auth['ok']
      client = ::Slack.realtime

      on_post = -> (request, text) { post(request, text) }
      @bot = Kirpich::Bot.new(on_post: on_post)

      client.on :message do |data|
        on_message(data)
      end

      client.on :reaction_added do |data|
        on_reaction(data)
      end

      client.start
    end

    def raise_auth_error
      Kirpich.logger.error "Slack auth error #{@auth['error']}"
      fail @auth['error']
    end

    def post(request, text)
      EM.next_tick do
        ::Slack.chat_postMessage as_user: true, channel: request.channel, text: text
      end
    rescue RuntimeError => e
      Kirpich.logger.error e
    end

    def on_message(data)
      request = Kirpich::Messaging::Slack::Request.new(data, @auth)
      @bot.on_message(request)
    end

    def on_reaction(data)
      member_id = data['user']
      reactions = ::Slack.post('reactions.list', user: member_id, count: 1)
      if reactions.key?('ok')
        reaction = reactions['items'].first
        if reaction['message']['ts'] == data['item']['ts']
          Kirpich::Twitter.add(reaction['message'])
        end
      end
    end
  end
end
