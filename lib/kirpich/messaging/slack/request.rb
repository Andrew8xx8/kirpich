module Kirpich::Messaging
  class Slack::Request
    include Virtus.model

    attribute :subtype, String
    attribute :type, String
    attribute :user, String
    attribute :text, String, default: ''
    attribute :channel, String
    attribute :ts, String

    def initialize(attrs, auth)
      super(attrs)
      @auth = auth
    end

    def respondable?
      return false if @auth["user_id"] == user
      return false if bot_message? || changed_message?
      return false if text.empty?

      true
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
