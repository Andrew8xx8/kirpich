module Kirpich
  class Bot
    include Virtus.model

    attribute :state, Hash, default: {}
    attribute :on_post, Proc

    def on_message(request)
      return unless request.respondable?

      state[request.channel] ||= {}

      answer = Kirpich::Brain.respond_on(request)

      return unless answer
      response = eval_answer(answer, request, state[request.channel])

      return unless response

      state[request.channel] = state[request.channel].merge(response.state)
      send_response(response, request)
    end

    private

    def eval_answer(answer, request, state)
      Kirpich.logger.info "Respond with #{answer.type}"

      if answer.type == :last_answer
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
        on_post.call(request, text)
      end
    end
  end
end
