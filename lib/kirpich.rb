require 'json'
require 'twitter'
require 'virtus'
require 'slack'
require 'nokogiri'
require 'open-uri'
require 'awesome_print'
require 'logstash-logger'
require 'active_support/core_ext/string/filters'
require 'kirpich/version'

module Kirpich
  autoload 'Dict',      'kirpich/dict'
  autoload 'Bot',       'kirpich/bot'
  autoload 'Answer',    'kirpich/answer'
  autoload 'Client',    'kirpich/client'
  autoload 'Brain',     'kirpich/brain'
  autoload 'Answers',   'kirpich/answers'
  autoload 'Text',      'kirpich/text'
  autoload 'Providers', 'kirpich/providers'
  autoload 'Request',   'kirpich/request'
  autoload 'Response',  'kirpich/response'
  autoload 'Twitter',   'kirpich/twitter'

  class << self
    def run
      Slack.configure do |config|
        config.token = ENV['TOKEN']
      end

      auth = Slack.auth_test
      fail auth['error'] unless auth['ok']

      client = Slack.realtime

      bot = Kirpich::Bot.new(client: Kirpich::Client.new, self_id: auth['user_id'])

      client.on :message do |data|
        bot.on_message(data)
      end

      client.on :hello do
        bot.on_hello
      end

      client.on :reaction_added do |data|
        member_id = data['user']
        reactions = Slack.post('reactions.list', user: member_id, count: 1)
        if reactions.key?('ok')
          reaction = reactions['items'].first
          if reaction['message']['ts'] == data['item']['ts']
            Kirpich::Twitter.add(reaction['message'])
          end
        end
      end

      client.start
    end

    def logger
      @logger ||= LogStashLogger.new(type: :stdout)
    end

    def twitter_enabled?
      ENV.key?('CONSUMER_KEY') && ENV.key?('CONSUMER_SECRET') && ENV.key?('ACCESS_TOKEN') && ENV.key?('ACCESS_SECRET')
    end

    def twitter
      @twitter ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['CONSUMER_KEY']
        config.consumer_secret     = ENV['CONSUMER_SECRET']
        config.access_token        = ENV['ACCESS_TOKEN']
        config.access_token_secret = ENV['ACCESS_SECRET']
      end
    end

    attr_writer :logger
  end
end
