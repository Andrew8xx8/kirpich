require 'json'
require 'twitter'
require 'virtus'
require 'slack'
require 'nokogiri'
require 'open-uri'
require 'logstash-logger'
require 'active_support'
require 'active_support/core_ext'
require 'kirpich/version'
require 'telegram/bot'

ActiveSupport::Dependencies.autoload_paths = ['lib/']

module Kirpich
  class << self

    def run
      config = Kirpich::Config.new_from_env(ENV)

      if config.gse_enabled?
        Kirpich::Providers::GoogleImageCustomSearch.api_key = config.gse_api_key
        Kirpich::Providers::GoogleImageCustomSearch.cx = config.gse_cx
      else
        Kirpich.logger.info 'Search via Google API is disabled. To enable it provide GSE_API_KEY and GSE_CX in env'
      end

      if config.telegram_enabled?
        messaging = Kirpich::Messaging::Telegram.new(token: config.telegram_token)
        messaging.start
      else
        Kirpich.logger.info 'Telegram is disabled. To enable it provide TELEGRAM_TOKEN in env'
      end

      if config.slack_enabled?
        messaging = Kirpich::Messaging::Slack.new(token: config.slack_token)
        messaging.start
      else
        Kirpich.logger.info 'Slack is disabled. To enable it provide SLACK_TOKEN in env'
      end
    end

    def logger
      @logger ||= LogStashLogger.new(type: :stdout)
    end

    def twitter
      @twitter ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = config.twitter_consumer_key
        config.consumer_secret     = config.twitter_consumer_secret
        config.access_token        = config.twitter_access_token
        config.access_token_secret = config.twitter_access_secret
      end
    end

    attr_writer :logger
  end
end
