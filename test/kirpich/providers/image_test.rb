require 'test_helper'
require 'kirpich/providers/image'

class Kirpich::Providers::ImageTest < Minitest::Test
  def setup
  end

  def test_les_400_image
    stub_request(:get, /les400culs.com.*/)
      .to_return(
        status: 200,
        body: load_fixture('les_400.html'),
        headers: {}
      )

    img = Kirpich::Providers::Image.les_400_image
    assert { !img.empty? }
  end

  def test_lesaintdesseins_image
    stub_request(:get, /lesaintdesseins.*/)
      .to_return(
        status: 200,
        body: load_fixture('lesaintdesseins.html'),
        headers: {}
      )

    img = Kirpich::Providers::Image.lesaintdesseins_image
    assert { !img.empty? }
  end
end
