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
      return false if text.empty?
      true
    end

    def to_s
      "Recived [#{text}] From [#{user}]"
    end
  end
end
