require 'kirpich/stem'

module Kirpich
  class Nlp
    attr_reader :stemmed, :original

    def initialize(text)
      @original = text.downcase
      @stemmed = Kirpich::Stem.stem(@original)
    end

    def question?
      @original =~ /\?$/
    end

    def appeal?
      @original =~ /\?$/
    end

  end
end
