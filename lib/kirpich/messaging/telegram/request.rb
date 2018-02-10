module Kirpich::Messaging
  class Telegram::Request
    include Virtus.model

    attribute :subtype, String
    attribute :type, String
    attribute :user, String
    attribute :text, String, default: ''
    attribute :channel, String
    attribute :ts, String

    def initialize(message)
      super({
        channel: message.chat.id,
        user: message.from.id,
        text: message.text,
        ts: message.date
      })
    end

    def respondable?
      p channel, user, text, ts
    end

    def bot_message?
      subtype == 'bot_message'
    end

    def changed_message?
      subtype == 'message_changed'
    end

    def to_s
      "Recived [#{text}] From [#{user}]"
    end
  end
end
