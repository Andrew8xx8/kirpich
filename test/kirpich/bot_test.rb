require 'test_helper'
require 'kirpich/bot'

class AnswersStub
  def method(method)
    proc { |name|
      method
    }
  end

  def method_missing(method_name, *args)
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

  def test_replay
    answer = @bot.select_text({'text' => 'КиРпиЧ, РазЪясни что', 'channel' => 'test'})
    assert { answer == :lurk_search }

    answer = @bot.select_text({'text' => 'кирпич, разъясни что', 'channel' => 'test'})
    assert { answer == :lurk_search }

    answer = @bot.select_text({'text' => 'кирпич, еще раз', 'channel' => 'test'})
    assert { answer == :lurk_search }

    answer = @bot.select_text({'text' => 'кирпич, повторика', 'channel' => 'test'})
    assert { answer == :lurk_search }
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
    assert { answer == :xxx_image }
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

  def test_good
    answer = @bot.select_text({'text' => 'паша красава', 'channel' => 'test'})
    assert { answer == :ok_text }

    answer = @bot.select_text({'text' => 'пашок красавчик', 'channel' => 'test'})
    assert { answer == :ok_text }

    answer = @bot.select_text({'text' => 'пашок молодчик', 'channel' => 'test'})
    assert { answer == :ok_text }
  end

  def test_call
    answer = @bot.select_text({'text' => 'пашок ты не приуныл ли случаем?', 'channel' => 'test'})
    assert { answer == :yes_no_text }

    answer = @bot.select_text({'text' => 'пашок ты сидел?', 'channel' => 'test'})
    assert { answer == :yes_no_text }

    answer = @bot.select_text({'text' => 'Паш, цены на нефть поднимутся?', 'channel' => 'test'})
    assert { answer == :yes_no_text }

    answer = @bot.select_text({'text' => 'Паш, нет?', 'channel' => 'test'})
    assert { answer == :yes_no_text }
  end
end
