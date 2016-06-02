module Kirpich::Providers
  class Ololo
    OLOLO_URL = 'http://ololo.cc/?lang=ru'.freeze

    def self.aphorism
      response = Faraday.get OLOLO_URL
      doc = Nokogiri::HTML(response.body)
      doc.css('p.quote').first.text
    end
  end
end
