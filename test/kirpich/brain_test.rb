# encoding: utf-8

require 'test_helper'

class Kirpich::BrainTest < Minitest::Test
  def setup
    @brain = Kirpich::Brain
  end

  def test_uebyvay_v_svoy_chat
    assert_answer('паш, что нужно делать если чат заебал?', :appeal_text)
  end

  def test_random_user
    assert_answer('кирпич, кто охуел?', :random_user)
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

  def test_boobs
    assert_answer('кирпич, покажи сиськи', :random_boobs_image)
  end

  def test_ass
    ass_requests = [
      "паш, покажи жопу",
      "паш, покажи классный попец",
      "паш, жопу",
    ]

    ass_requests.each do |ass_request|
      assert_answer(ass_request, :random_ass_image)
    end
  end

  def test_poh
    assert_answer('среда', :appeal_text)
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

  def assert_answer(text, method, args = [])
    request = Kirpich::Request.new(text: text,
                                   channel: 'test')
    answer = @brain.respond_on(request)

    assert { method == answer.type }
    if args.any?
      args.each_with_index do |arg, i|
        assert { arg == answer.args[i] }
      end
    end
  end
end
