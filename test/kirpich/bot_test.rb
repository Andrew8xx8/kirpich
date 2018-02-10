# encoding: utf-8

require 'test_helper'

class RequestStub
  include Virtus.model

  attribute :respondable, Boolean
  attribute :channel, String
  attribute :text, String

  def respondable?
    respondable
  end
end

class Kirpich::BotTest < Minitest::Test
  def setup
    @posts = []
    on_post = -> (_, text) {
      @posts << [text]
    }
    @bot = Kirpich::Bot.new(on_post: on_post)
  end

  def test_no_respond_for_empty_request
    request = RequestStub.new(respondable: true, text: '')
    @bot.on_message(request)
    assert @posts.empty?
  end

  def test_respond_on_hello
    request = RequestStub.new(respondable: true, text: 'Привет!')
    @bot.on_message(request)
    assert @posts.any?
  end

  def test_respond_with_last_answer
    request = RequestStub.new(respondable: true, text: 'паш, как дела')
    @bot.on_message(request)

    request = RequestStub.new(respondable: true, text: 'паш, еще')
    @bot.on_message(request)
    assert @posts.count == 2
  end

end
