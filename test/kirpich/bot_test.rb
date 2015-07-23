require 'test_helper'
require 'kirpich/bot'

class AnswersStub
  def method_missing(method_name)
    p method_name
    method_name
  end
end

class Kirpich::BotTest < Minitest::Test
  def setup
    @bot = Kirpich::Bot.new({
      answers: AnswersStub.new,
      client: nil
    })
  end

  def test_explain
    answer = @bot.select_text({'text' => 'кирпич, разъясни что', 'channel' => 'test'})
    assert { answer == :do_not_know_text }

    answer = @bot.select_text({'text' => 'кирпич, разъясни что такое гопник', 'channel' => 'test'})
    p answer
    assert { answer == :do_not_know_text }
  end
end
