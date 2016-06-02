require 'test_helper'
require 'kirpich/providers/ololo'

class Kirpich::Providers::OloloTest < Minitest::Test
  def test_wisdom
    stub_request(:get, 'http://ololo.cc/?lang=ru')
      .to_return(status: 200, body: load_fixture('ololo.html'), headers: {})
    wisdom = Kirpich::Providers::Ololo.wisdom
    assert_equal("Дареному коню кулаками не машут\n", wisdom)
  end
end
