# frozen_string_literal: true

module Kirpich::Providers
  class Oboobs
    def boobs
      picture_url(api_url: 'http://api.oboobs.ru/boobs/0/1/random',
        cdn_host: 'http://media.oboobs.ru/')
    end

    def butts
      picture_url(api_url: 'http://api.obutts.ru/butts/0/1/random',
        cdn_host: 'http://media.obutts.ru/')
    end

    private

    def picture_url(api_url:, cdn_host:)
      response = Faraday.get(api_url)
      json = JSON.parse(response.body)
      preview_url = json.first.fetch('preview')
      "#{cdn_host}#{preview_url}"
    end
  end
end

# API docs
#
# boobs: "/boobs/{start=0; sql offset}/{count=1; sql limit}/{order=-id;[id,rank,-rank,interest,-interest,random]}/",
# example: "/boobs/10/20/rank/" - get 20 boobs elements, start from 10th ordered by rank;
#
# noise: "/noise/{count=1; sql limit}/",
# example: "/noise/50/" - get 50 random noise elements;
#
# model search: "/boobs/model/{model; sql ilike}/",
# example: "/boobs/model/something/" - get all boobs elements, where model name contains "something", ordered by id;
#
# author search: "/boobs/author/{author; sql ilike}/",
# example: "/boobs/author/something/" - get all boobs elements, where author name contains "something", ordered by id;
#
# get boobs by id: "/boobs/get/{id=0}/",
# example: "/boobs/get/6202/" - get boobs element with id 6202;
#
# get boobs count: "/boobs/count/";
# get noise count: "/noise/count/";
#
# vote for boobs: "/boobs/vote/{id=0}/{operation=plus;[plus,minus]}/",
# example: "/boobs/vote/6202/minus/" - negative vote for boobs with id 6202;
#
# vote for noise: "/noise/vote/{id=0}/{operation=plus;[plus,minus]}/",
# example: "/noise/vote/57/minus/" - negative vote for noise with id 57;
