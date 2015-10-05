module Kirpich
  class Answer
    attr_reader :type
    attr_reader :args

    def initialize(type, *args)
      @type = type
      @args = args
    end
  end
end
