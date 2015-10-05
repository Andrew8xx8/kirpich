require 'virtus'
require 'kirpich/version'
require 'logstash-logger'
require 'slack'
require 'nokogiri'
require 'open-uri'
require 'json'

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

      client.start
    end

    def logger
      @logger ||= LogStashLogger.new(type: :stdout)
    end

    attr_writer :logger
  end
end
