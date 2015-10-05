require 'test_helper'

class Kirpich::AnswersTest < Minitest::Test
  def setup
    @answers = Kirpich::Answers
  end

  def test_currency
    stub_request(:get, /query.yahooapis.com/)
      .to_return(status: 200, body: load_fixture('yahoo.json'), headers: {})
    request = Kirpich::Request.new
    response = @answers.currency(request, {})
    assert { response.body.first.include?('dollar') }
  end

  def test_currency_up
    stub_request(:get, /query.yahooapis.com/)
      .to_return(status: 200, body: load_fixture('yahoo.json'), headers: {})
    request = Kirpich::Request.new
    response = @answers.currency(request, pc: { 'USD/RUB' => '66.0545', 'EUR/RUB' => '74.0279' })
    assert { response.body.first.include?('chart_with_upwards_trend') }
  end

  def test_currency_down
    stub_request(:get, /query.yahooapis.com/)
      .to_return(status: 200, body: load_fixture('yahoo.json'), headers: {})
    request = Kirpich::Request.new
    response = @answers.currency(request, pc: { 'USD/RUB' => '66.3545', 'EUR/RUB' => '74.4279' })
    assert { response.body.first.include?('chart_with_downwards_trend') }
  end
end
