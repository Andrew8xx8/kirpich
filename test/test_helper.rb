$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'kirpich'

require 'minitest/autorun'
require 'webmock'

require 'wrong'
require 'wrong/adapters/minitest'

class Minitest::Test
  include Wrong
end
