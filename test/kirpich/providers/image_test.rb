require 'test_helper'
require 'kirpich/providers/image'

class Kirpich::Providers::ImageTest < Minitest::Test
  def setup
  end

  def test_ass_image
    stub_request(:get, /hellasweetass.tumblr.com.*/)
      .to_return(
        status: 200,
        body: load_fixture('les_400.html'),
        headers: {}
      )

    img = Kirpich::Providers::Image.ass_image
    assert { !img.empty? }
  end

  def test_boobs_image
    stub_request(:get, /boobsarethegreatest.*/)
      .to_return(
        status: 200,
        body: load_fixture('lesaintdesseins.html'),
        headers: {}
      )

    img = Kirpich::Providers::Image.boobs_image
    assert { !img.empty? }
  end

  def test_developerslife_image
    stub_request(:get, 'http://developerslife.ru/random')
      .to_return(status: 302, body: '', headers: { location: '//developerslife.ru/1' })

    stub_request(:get, 'http://developerslife.ru/1')
      .to_return(status: 200, body: load_fixture('developerslife.html'), headers: {})

    img = Kirpich::Providers::Image.developerslife_image
    assert { !img.empty? }
  end

  def test_devopsreactions_image
    stub_request(:get, 'http://devopsreactions.tumblr.com/random')
      .to_return(status: 302, body: '', headers: { location: 'http://devopsreactions.tumblr.com/post/130607786417/sales-people-looking-for-someone-to-help-them' })

    stub_request(:get, 'http://devopsreactions.tumblr.com/post/130607786417/sales-people-looking-for-someone-to-help-them')
      .to_return(status: 200, body: load_fixture('devopsreactions.html'), headers: {})

    img = Kirpich::Providers::Image.devopsreactions_image
    assert { !img.empty? }
  end
end
