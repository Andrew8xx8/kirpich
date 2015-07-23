require 'test_helper'
require 'kirpich/bot'

class AnswersStub
  def method_missing(method_name, *args)
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
    assert { answer == :lurk_search }

    answer = @bot.select_text({'text' => 'кирпич, разъясни что такое гопник', 'channel' => 'test'})
    assert { answer == :lurk_search }

    answer = @bot.select_text({'text' => 'кирпич, что такое гопник', 'channel' => 'test'})
    assert { answer == :lurk_search }
  end

  def test_boobs
    answer = @bot.select_text({'text' => 'кирпич, покажи сиськи', 'channel' => 'test'})
    assert { answer == :inferot_image }
  end

  def test_poh
    answer = @bot.select_text({'text' => 'среда', 'channel' => 'test'})
    assert { answer == :poh_text }
  end

  def test_hello
    answer = @bot.select_text({'text' => 'Кипич, привет', 'channel' => 'test'})
    assert { answer == :hello_text }
  end

  def test_currency
    answer = @bot.select_text({'text' => 'Паш, курс', 'channel' => 'test'})
    assert { answer == :currency }
  end

  def test_main
    answer = @bot.select_text({'text' => 'Паш, кто главный', 'channel' => 'test'})
    assert { answer == :chef_text }
  end

end
