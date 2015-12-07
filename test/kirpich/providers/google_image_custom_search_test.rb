require 'test_helper'
require 'kirpich/providers/google_image_custom_search'

class Kirpich::Providers::GoogleImageCustomSearchTest < Minitest::Test
  def setup
    Kirpich::Providers::GoogleImageCustomSearch.api_key = 'TeStApIkEy'
    Kirpich::Providers::GoogleImageCustomSearch.cx = 'test:cx'
  end

  def test_search_image
    stub_request(:get, /www.googleapis.com\/customsearch.*/)
      .to_return(status: 200,
        body: load_fixture('google_image_custom_search.json'),
        headers: {})

    img = Kirpich::Providers::GoogleImageCustomSearch.search('покажи дилдо')

    assert { img =~ /jpg/ }
  end
end
