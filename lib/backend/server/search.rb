require 'goliath'
require_relative '../config/mongo.rb'

module Linkorama
  class Search < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::Formatters::JSON
    use Goliath::Rack::Render

    def response(env)

      #MONGO.find({'_keywords':'www'}, {'title': 1}, {'url': 1})
      [200, {}, [{id: '1', name: 'pepe', url: 'www.uva.es'}]]
    end
  end
end
