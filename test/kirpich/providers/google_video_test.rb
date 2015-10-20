require 'test_helper'
require 'kirpich/providers/google_video'

class Kirpich::Providers::GoogleVideoTest < Minitest::Test
  def setup
  end

  def test_search_image
    stub_request(:get, /ajax.googleapis.com.*/)
      .to_return(status: 200,
                 body: load_fixture('google_videos.json'),
                 headers: {}
                )

    img = Kirpich::Providers::GoogleVideo.search('покажи боба марли')
    assert { img == "https://www.youtube.com/watch?v=1A0VPgMDQ14" }
  end
end
