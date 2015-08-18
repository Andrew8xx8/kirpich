require 'test_helper'
require 'kirpich/providers/lurk'

class Kirpich::Providers::LurkTest < Minitest::Test
  def setup
  end

  def test_search_image
    stub_request(:get, "http://lurkmore.to/index.php?title=%D0%B1%D0%BE%D0%B1_%D0%BC%D0%B0%D1%80%D0%BB%D0%B8").
      to_return(:status => 200,
                :body => 'Please follow the redirect to /%D0%B1%D0%BE%D0%B1_%D0%BC%D0%B0%D1%80%D0%BB%D0%B8root@2071a2f83909',
                :headers => {}
                )

      stub_request(:get, "http://lurkmore.to/%D0%B1%D0%BE%D0%B1_%D0%BC%D0%B0%D1%80%D0%BB%D0%B8root@2071a2f83909").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.1'}).
        to_return(
          :status => 200,
          :body => load_fixture("lurk_ok.html"),
          :headers => {}
        )

    img = Kirpich::Providers::Lurk.search('боб марли')
    p img
    assert { img.any? }
  end

end
