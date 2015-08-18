require 'test_helper'
require 'kirpich/providers/google_image'

class Kirpich::Providers::GoogleImageTest < Minitest::Test
  def setup
  end

  def test_search_image
    stub_request(:get, /ajax.googleapis.com.*/).
      to_return(:status => 200,
                :body => load_fixture("google_images.json"),
                :headers => {}
                )

    img = Kirpich::Providers::GoogleImage.search('покажи боба марли')
    assert { img =~ /jpg/ }
  end

  def test_search_xxx_image
    stub_request(:get, /ajax.googleapis.com.*/).
      to_return(:status => 200,
                :body => load_fixture("google_images.json"),
                :headers => {}
                )

    img = Kirpich::Providers::GoogleImage.search_xxx('покажи боба марли')
    assert { img =~ /jpg/ }
  end

end
