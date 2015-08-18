require 'test_helper'
require 'kirpich/providers/text'

class Kirpich::Providers::LurkTest < Minitest::Test
  def setup
  end

  def test_interfax
    stub_request(:get, "http://www.interfax.ru/").
        to_return(
          :status => 200,
          :body => load_fixture("interfax.html"),
          :headers => {}
        )

    text = Kirpich::Providers::Text.interfax
    assert { !text.empty? }
  end

  def test_ria
    stub_request(:get, "http://ria.ru/").
      to_return(
        :status => 200,
        :body => load_fixture("ria.html"),
        :headers => {}
    )

    text = Kirpich::Providers::Text.ria
    assert { !text.empty? }
  end

end
