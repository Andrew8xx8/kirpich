# encoding: utf-8

require 'test_helper'

class ClientStub
  attr_reader :post_called
  attr_reader :post_after_called

  def post(params, _)
    @post_called = true
    params
  end

  def post_after(time)
    @post_after_called = true
    time
  end
end

class Kirpich::BotTest < Minitest::Test
  def setup
    @client = ClientStub.new
    @bot = Kirpich::Bot.new(client: @client, self_id: 'test')
  end

  def test_on_message
    slack_message = { 'type' => 'message', 'user' => 'U081B2XCP', 'text' => 'а?', 'channel' => 'D081AUUHW', 'ts' => '1443994452.000009' }
    @bot.on_message(slack_message)

    assert @client.post_called
  end

  def test_on_message_when_text_is_absent
    slack_message = {
      'type' => 'message',
      'subtype' => 'message_deleted',
      'hidden' => true,
      'channel' => 'C024BE91L',
      'ts' => '1358878755.000001',
      'deleted_ts' => '1358878749.000002',
      'event_ts' => '1358878755.000002',
    }

    assert_nil @bot.on_message(slack_message)
  end
end
