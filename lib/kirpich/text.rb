require 'kirpich/stem'

module Kirpich
  class Text
    APPEAL_REGEX = /^(паштет|пашок|пашка|кирпич|паш|пацантре|народ|кто-нибудь|kirpich)/i
    attr_reader :clean, :original

    def initialize(text)
      @original = text
      @clean = text.downcase.gsub(APPEAL_REGEX, '')
    end

    def question?
      @original =~ /\?$/
    end

    def appeal?
      @original =~ APPEAL_REGEX
    end

  end
end
