require 'logstash-logger'
require "kirpich/version"
require "kirpich/dict"
require "kirpich/bot"
require 'slack'

module Kirpich
  class << self
    def run
      Slack.configure do |config|
        config.token = ENV['TOKEN']
      end

      auth = Slack.auth_test
      fail auth['error'] unless auth['ok']

      client = Slack.realtime

      bot = Kirpich::Bot.new({
        answers: Kirpich::Answers.new,
        client: client
      })

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

    def logger=(logger)
      @logger = logger
    end
  end
end
