require 'test_helper'

class Kirpich::Providers::TextUtilsTest < Minitest::Test
  def test_materialize
    source = 'Lorem Ipsum' * 1000
    text = Kirpich::Providers::TextUtils.materialize(source)
    assert { text.length > source.length }
  end
end
