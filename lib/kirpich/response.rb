module Kirpich
  class Response
    include Virtus.model

    attribute :state, Hash, default: {}
    attribute :body,  Array, default: []
  end
end
