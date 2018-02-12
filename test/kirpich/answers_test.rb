require 'test_helper'

class Kirpich::AnswersTest < Minitest::Test
  def setup
    @answers = Kirpich::Answers
  end

  def test_slots
    user = 'test'
    request = Kirpich::Request.new(text: 'спин', user: user)
    response = Kirpich::Answers.slots(request, { slots: { another_user: 100 }, test: true }, 1, 1)
    assert { response.state[:test].present? }
    assert { response.state[:slots][user].present? }
    assert { response.state[:slots][:another_user].present? }
  end
end
