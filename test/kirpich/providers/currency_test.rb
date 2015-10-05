require 'test_helper'

class Kirpich::Providers::CurrencyTest < Minitest::Test
  def setup
  end

  def test_usd_rub_eur_rub
    stub_request(:get, /query.yahooapis.com/)
      .to_return(status: 200, body: load_fixture('yahoo.json'), headers: {})

    result = Kirpich::Providers::Currency.usd_rub_eur_rub
    assert { !result.empty? }
  end
end
