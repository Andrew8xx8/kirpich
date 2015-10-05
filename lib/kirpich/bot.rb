module Kirpich
  class Bot
    include Virtus.model

    attribute :client
    attribute :self_id, String
    attribute :state,   Hash, default: {}

    def on_message(data)
      request = Kirpich::Request.new(data)

      return unless can_respond?(request)

      state[request.channel] ||= {}
      answer = Kirpich::Brain.respond_on(request)
      response = eval_answer(answer, request, state[request.channel])

      return unless response

      state[request.channel] = state[request.channel].merge(response.state)
      send_response(response, request)
    end

    def on_hello
      Kirpich.logger.info 'I am touch!'
      random_post_timer
    end

    private

    def can_respond?(request)
      return false if self_id == request.user
      return false if request.bot_message? || request.changed_message?
      return false if request.text.empty?

      true
    end

    def eval_answer(answer, request, state)
      return unless answer

      Kirpich.logger.info "Respond with #{answer.type}"

      if answer.type == :last_answer && state[:last_answer].is_a?(Kirpich::Answer)
        answer = state[:last_answer]
      else
        state[:last_answer] = answer
      end

      return unless answer

      method_object = Kirpich::Answers.method(answer.type)
      method_object.call(request, state, *answer.args)
    end

    def send_response(response, request)
      return unless response.body.any?

      response.body.each do |text|
        client.post text, request
      end
    end

    def random_response
      methods = [:random_boobs_image, :random_ass_image, :news_text, :currency]
      method_object = @answers.method(methods.sample)

      Kirpich::Response.new body: method_object.call
    end

    def random_post_timer
      time = 5000 + rand(8000)

      client.post_after(time) do
        request = Kirpich::Request.new channel: %w(C08189F96 G084E5SC9).sample
        send_response(random_response, request)

        random_post_timer
      end
    end
  end
end
