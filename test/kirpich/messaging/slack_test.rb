# encoding: utf-8

require 'test_helper'

def constrcut_message(text, user = 'U081B2XCP')
  { 'type' => 'message', 'user' => user, 'text' => text, 'channel' => 'D081AUUHW', 'ts' => '1443994452.000009' }
end

class Kirpich::Messaging::SlackTest < Minitest::Test
  def setup
    @posts = []
    on_post = -> (_, text) {
      @posts << [text]
    }
    @bot = Kirpich::Bot.new(on_post: on_post)
  end

  def test_on_message
    auth = { 'user_id' => 'U081B2XCR' }
    data = constrcut_message('а?')
    request = Kirpich::Messaging::Slack::Request.new(data, auth)
    @bot.on_message(request)
    assert @posts.any?
  end

  def test_not_respond_on_self_message
    auth = { 'user_id' => 'U081B2XCP' }
    data = constrcut_message('а?', auth['user_id'])
    request = Kirpich::Messaging::Slack::Request.new(data, auth)
    @bot.on_message(request)
    assert @posts.empty?
  end

  def test_on_all_messages
    assert @posts.empty?
  end
end
