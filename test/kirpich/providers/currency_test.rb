require 'test_helper'

class Kirpich::Providers::CurrencyTest < Minitest::Test
  def test_usd_rub_eur_rub_btc
    stub_request(:get, /quote.rbc.ru/)
      .to_return(status: 200, body: load_fixture('rbc.json'), headers: {})

    result = Kirpich::Providers::Currency.usd_rub_eur_rub_btc
    assert { !result.empty? }
  end
end
