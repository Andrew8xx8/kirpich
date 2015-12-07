require 'test_helper'
require 'kirpich/providers/google_image'

class Kirpich::Providers::GoogleImageTest < Minitest::Test
  def setup
  end

  def test_search_image
    stub_request(:get, /ajax.googleapis.com.*/)
      .to_return(status: 200,
                 body: load_fixture('google_images.json'),
                 headers: {}
                )

    img = Kirpich::Providers::GoogleImage.search('покажи боба марли')
    assert { img =~ /jpg/ }
  end

  def test_search_with_deprecated_response
    stub_request(:get, /ajax.googleapis.com.*/)
      .to_return(status: 200,
                 body: load_fixture('google_images_deprecated.json'),
                 headers: {}
                )

    img = Kirpich::Providers::GoogleImage.search('покажи боба марли')
    assert_nil img
  end
end
