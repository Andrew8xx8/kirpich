module Kirpich
  class Twitter
    REACTIONS = %w(+1 smiley heavy_plus_sign joy grinning ok_hand clap white_check_mark heart)

    class << self
      def add(message)
        count = calc_reactions(message)
        Kirpich.logger.info "Reaction with #{count} good slmiles added."
        return unless count > 2

        EM.defer do
          update(message)
        end
      end

      def update(message)
        if message.key?('attachments') && message['attachments'].any?
          update_with_media(message)
        elsif message.key('text')
          update_with_text(message)
        end
      end

      def update_with_media(message)
        text = message['text'].gsub(/<.*?>/, '')
        text = Kirpich::Dict::ZBS.sample if text.empty?

        images = message['attachments'].map do |a|
          open(a['image_url'])
        end

        Kirpich.logger.info "Update with text #{text} and image #{message['attachments'].first}"
        Kirpich.twitter.update_with_media(text, images.first)
      end

      def update_with_text(message)
        text = message['text']
        Kirpich.logger.info "Update with text #{text}"
        Kirpich.twitter.update(text.truncate(255))
      end

      def calc_reactions(message)
        good_reactions = message['reactions'].select do |reaction|
          REACTIONS.include?(reaction['name'])
        end

        votes = good_reactions.map do |reaction|
          reaction['count']
        end

        votes.reduce(0, :+)
      end
    end
  end
end
