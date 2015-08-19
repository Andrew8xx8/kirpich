require 'test_helper'
require 'kirpich/providers/fga'

class Kirpich::Providers::FgaTest < Minitest::Test
  def setup
  end

  def test_random
    stub_request(:get, "http://fucking-great-advice.ru/api/random").
        to_return(
          :status => 200,
          :body => load_fixture("fga.json"),
          :headers => {}
        )

    text = Kirpich::Providers::Fga.random
    assert { !text.empty? }
  end

end
