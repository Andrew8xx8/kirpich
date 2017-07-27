module Kirpich
  module Providers
    autoload 'Currency', 'kirpich/providers/currency'
    autoload 'Clarifai', 'kirpich/providers/clarifai'
    autoload 'GoogleImage', 'kirpich/providers/google_image'
    autoload 'GoogleImageCustomSearch', 'kirpich/providers/google_image_custom_search'
    autoload 'GoogleVideo', 'kirpich/providers/google_video'
    autoload 'Lurk', 'kirpich/providers/lurk'
    autoload 'Text', 'kirpich/providers/text'
    autoload 'Image', 'kirpich/providers/image'
    autoload 'Fga', 'kirpich/providers/fga'
    autoload 'SlackUser', 'kirpich/providers/slack_user'
    autoload 'Ololo', 'kirpich/providers/ololo'

    autoload 'TextUtils', 'kirpich/providers/text_utils'
  end
end
