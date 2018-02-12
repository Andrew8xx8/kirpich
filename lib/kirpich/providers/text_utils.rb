module Kirpich::Providers
  class TextUtils
    class << self
      def replace_consts(text)
        appeal = Kirpich::Dict::APPEAL.sample
        text.gsub(':APPEAL:', appeal)
      end

      def materialize(text)
        result = []
        text.split(' ').each do |word|
          if word != 'материализуй'
            result << word

            if word.size > 3 && !(word =~ /[,.:;!?'\"\/#$%^&*()]/) && rand(7) == 5
              result << Kirpich::Dict::MEJ.sample
            end
          end
        end

        result.join(' ')
      end
    end
  end
end
