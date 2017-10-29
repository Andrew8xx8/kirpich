module Kirpich
  class Text
    APPEAL_REGEX = /\s*\b(паштет|пашок|пашка|кирпич|паш|пацантре|народ|кто-нибудь|kirpich)\b,?\s*/i

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

    def fap?
      arrays = Kirpich::Dict::BUTT.keys + Kirpich::Dict::BOOBS.keys
      words = arrays.join('|')
      @original =~ /(#{words})/i
    end
  end
end
