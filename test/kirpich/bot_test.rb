# encoding: utf-8

require 'test_helper'

class AnswersStub
  def method(method)
    proc do |*args|
      {
        method: method,
        args: args
      }
    end
  end

  def method_missing(method_name, *_args)
    method_name
  end
end

class Kirpich::BotTest < Minitest::Test
  def setup
    @bot = Kirpich::Bot.new(answers: AnswersStub.new,
                            client: nil)
  end

  def test_replay
    answer = @bot.select_text('text' => 'КиРпиЧ, РазЪясни что', 'channel' => 'test')
    assert_answer(answer, :lurk_search)

    answer = @bot.select_text('text' => 'кирпич, разъясни что', 'channel' => 'test')
    assert_answer(answer, :lurk_search)

    answer = @bot.select_text('text' => 'кирпич, еще раз', 'channel' => 'test')
    assert_answer(answer, :lurk_search)

    answer = @bot.select_text('text' => 'кирпич, повторика', 'channel' => 'test')
    assert_answer(answer, :lurk_search)
  end

  def test_explain
    answer = @bot.select_text('text' => 'кирпич, разъясни что', 'channel' => 'test')
    assert_answer(answer, :lurk_search)

    answer = @bot.select_text('text' => 'кирпич, разъясни что такое гопник', 'channel' => 'test')
    assert_answer(answer, :lurk_search)

    answer = @bot.select_text('text' => 'кирпич, что такое гопник', 'channel' => 'test')
    assert_answer(answer, :lurk_search)
  end

  def test_boobs
    answer = @bot.select_text('text' => 'кирпич, покажи сиськи', 'channel' => 'test')
    assert_answer(answer, :random_boobs_image)
  end

  def test_poh
    answer = @bot.select_text('text' => 'среда', 'channel' => 'test')
    assert_answer(answer, :poh_text)
  end

  def test_hello
    answer = @bot.select_text('text' => 'Кипич, привет', 'channel' => 'test')
    assert_answer(answer, :hello_text)
  end

  def test_currency
    answer = @bot.select_text({ 'text' => 'Паш, курс', 'channel' => 'test' })
    assert_answer(answer, :currency)
  end

  def test_main
    answer = @bot.select_text('text' => 'Паш, кто главный', 'channel' => 'test')
    assert_answer(answer, :chef_text)
  end

  def test_good
    answer = @bot.select_text('text' => 'паша красава', 'channel' => 'test')
    assert_answer(answer, :ok_text)

    answer = @bot.select_text('text' => 'пашок красавчик', 'channel' => 'test')
    assert_answer(answer, :ok_text)

    answer = @bot.select_text('text' => 'пашок молодчик', 'channel' => 'test')
    assert_answer(answer, :ok_text)
  end

  def test_choose
    answer = @bot.select_text('text' => 'пашок, красное, синее или зеленое?', 'channel' => 'test')
    assert_answer(answer, :choose_text, [%w(красное синее зеленое)])
  end

  def test_call
    answer = @bot.select_text({ 'text' => 'пашок ты не приуныл ли случаем?', 'channel' => 'test' })
    assert_answer(answer, :choose_text)

    answer = @bot.select_text('text' => 'пашок ты сидел?', 'channel' => 'test')
    assert_answer(answer, :choose_text)

    answer = @bot.select_text({ 'text' => 'Паш, цены на нефть поднимутся?', 'channel' => 'test' })
    assert_answer(answer, :choose_text)

    answer = @bot.select_text({ 'text' => 'Паш, нет?', 'channel' => 'test' })
    assert_answer(answer, :choose_text)
  end

  def assert_answer(answer, method, args = [])
    assert { method == answer[:method] }
    if args.any?
      args.each_with_index do |arg, i|
        assert { arg == answer[:args][i] }
      end
    end
  end
end
