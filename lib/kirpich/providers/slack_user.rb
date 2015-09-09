module Kirpich::Providers
  class SlackUser
    class << self
      def random(channel)
        channel = _channel_info(channel)

        return unless channel && channel.key?('members') && channel['members'].any?

        member_id = channel['members'].sample
        user_info = Slack.users_info(user: member_id)

        return unless user_info.key?('ok')
        user_info['user']
      end

      def _channel_info(channel)
        if channel && channel[0] == 'C'
          info = Slack.channels_info(channel: channel)
          info = info['channel'] if info && info.key?('ok')
        else
          info = Slack.groups_info(channel: channel)
          info = info['group'] if info && info.key?('ok')
        end
      end
    end
  end
end
