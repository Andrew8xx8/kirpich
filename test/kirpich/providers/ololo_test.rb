require 'test_helper'
require 'kirpich/providers/ololo'

class Kirpich::Providers::OloloTest < Minitest::Test
  def test_aphorism
    stub_request(:get, 'http://ololo.cc/?lang=ru')
      .to_return(status: 200, body: load_fixture('ololo.html'), headers: {})
    aphorism = Kirpich::Providers::Ololo.aphorism
    assert_equal("Дареному коню кулаками не машут\n", aphorism)
  end
end
