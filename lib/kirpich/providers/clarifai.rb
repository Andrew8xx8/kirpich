module Kirpich::Providers
  class Clarifai
    class << self
      def clarifai_image(url)
        return Kirpich::Dict::POX.sample unless ENV['CLARIFAI_KEY']
        connection = Faraday.new(url: 'https://api.clarifai.com/v2/models/aaa03c23b3724a16a56b629203edc62c/outputs'.freeze)
        response = connection.post do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Key #{ENV['CLARIFAI_KEY']}"
          json = {
            inputs: [
              data: {
                image: {
                  url: url
                }
              }
            ]
          }
          req.body = json.to_json
        end

        json = JSON.parse(response.body)
        return Kirpich::Dict::NO_CONTENT.sample unless json['outputs'] && json['outputs'].any? && json['outputs'].first['data'] && json['outputs'].first['data']['concepts']
        json['outputs'].first['data']['concepts'].map do |c|
          c['name']
        end.join(', ')
      end
    end
  end
end
