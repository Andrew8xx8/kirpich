require 'test_helper'

class Kirpich::Providers::CurrencyTest < Minitest::Test
  def test_usd_rub_eur_rub_btc
    stub_request(:get, /world.investfunds.ru/)
      .to_return(status: 200, body: load_fixture('wir.json'), headers: {})

    result = Kirpich::Providers::Currency.usd_rub_eur_rub_btc
    assert { !result.empty? }
  end
end
