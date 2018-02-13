# encoding: utf-8

require 'test_helper'

class Kirpich::BrainTest < Minitest::Test
  def setup
    @brain = Kirpich::Brain
  end

  def test_texts
    assert_answer('паш, 300', :text)
    assert_answer('паш, триста', :text)
    assert_answer('паш, ладно', :text)
  end

  def test_uebyvay_v_svoy_chat
    assert_answer('паш, что нужно делать если чат заебал?', :appeal_text)
  end

  def test_kak_dela
    request = build_request('паш как дела?')
    answer = @brain.respond_on(request)
    assert_equal(:appeal_text, answer.type)
    assert { Kirpich::Dict::KAK_DELA.include?(answer.args.first) }
  end

  def test_random_user
    assert_answer('кирпич, кто охуел?', :random_user)
    assert_answer('кирпич, кто тут всех заебал?', :random_user)
  end

  def test_again
    assert_answer('кирпич, еще раз', :last_answer)
    assert_answer('кирпич, повторика', :last_answer)
  end

  def test_explain
    assert_answer('КиРпиЧ, РазЪясни что', :lurk_search)
    assert_answer('кирпич, разъясни что', :lurk_search)
    assert_answer('кирпич, разъясни что такое гопник', :lurk_search)
    assert_answer('кирпич, что такое гопник', :lurk_search)
  end

  def test_poh
    assert_answer('среда', :appeal_text)
  end

  def test_ladno
    assert_answer('да ладно', :text)
  end

  def test_trista
    assert_answer('использовали константу - 300', :text)
    assert_answer('делали так раз триста', :text)
  end

  def test_hello
    assert_answer('Кипич, привет', :appeal_text)
  end

  def test_currency
    assert_answer('Паш, курс', :currency)
  end

  def test_main
    assert_answer('Паш, кто главный', :appeal_text)
  end

  def test_good
    assert_answer('паштет красава', :appeal_text)
    assert_answer('пашок красавчик', :appeal_text)
    assert_answer('пашок молодчик', :appeal_text)
  end

  def test_choose
    assert_answer('пашок, красное, синее или зеленое?', :choose_text, [%w(красное синее зеленое)])
  end

  def test_call
    assert_answer('пашок ты не приуныл ли случаем?', :choose_text)
    assert_answer('пашок ты сидел?', :choose_text)
    assert_answer('Паш, цены на нефть поднимутся?', :choose_text)
  end

  def test_aphorism
    assert_answer('паш афоризм', :aphorism)
  end

  def test_admin
    assert_answer('паш про админов давай', :devopsreactions_image)
  end

  def test_slots_rules
    assert_answer('паш, как поднять бабла?', :slots_rules)
  end

  def test_slots_spin
    request = build_request('спин')
    answer = @brain.respond_on(request)
    assert { answer.type == :spin }
    assert { answer.args == [1, 1] }

    request = build_request('царский спин')
    answer = @brain.respond_on(request)
    assert { answer.args == [1, 2] }

    request = build_request('спин на первую')
    answer = @brain.respond_on(request)
    assert { answer.args == [0, 1] }

    request = build_request('царский спин на третью')
    answer = @brain.respond_on(request)
    assert { answer.args == [2, 2] }

    request = build_request('фартовый спин на третью')
    answer = @brain.respond_on(request)
    assert { answer.args == [2, 3] }
  end

  def assert_answer(text, method, args = [])
    request = build_request(text)
    answer = @brain.respond_on(request)

    assert { method == answer.type }
    if args.any?
      args.each_with_index do |arg, i|
        assert { arg == answer.args[i] }
      end
    end
  end

  def build_request(text)
    Kirpich::Request.new(text: text, channel: 'test')
  end
end
