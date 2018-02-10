module Kirpich
  class Config
    include Virtus.model

    attribute :slack_token, String
    attribute :telegram_token, String
    attribute :twitter_access_secret, String
    attribute :twitter_access_token, String
    attribute :twitter_consumer_key, String
    attribute :twitter_consumer_secret, String
    attribute :gse_api_key, String
    attribute :gse_cx, String
    attribute :random_channels, String

    def gse_enabled?
      gse_api_key.present? && gse_cx.present?
    end

    def twitter_enabled?
      twitter_access_secret.present? && twitter_access_token.present? && twitter_consumer_key.present? && twitter_consumer_secret.present?
    end

    def telegram_enabled?
      telegram_token.present?
    end

    def slack_enabled?
      slack_token.present?
    end

    class << self
      def new_from_env(env)
        new(
          slack_token:             env['SLACK_TOKEN'],
          telegram_token:          env['TELEGRAM_TOKEN'],
          twitter_access_secret:   env['TWITTER_ACCESS_SECRET'],
          twitter_access_token:    env['TWITTER_ACCESS_TOKEN'],
          twitter_consumer_key:    env['TWITTER_CONSUMER_KEY'],
          twitter_consumer_secret: env['TWITTER_CONSUMER_SECRET'],
          gse_api_key:             env['GSE_API_KEY'],
          gse_cx:                  env['GSE_CX'],
          random_channels:         env['RANDOM_CHANNELS'],
        )
      end
    end
  end
end
