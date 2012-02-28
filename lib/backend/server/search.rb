require 'goliath'
require_relative '../config/mongo.rb'

module Linkorama
  class Search < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::Formatters::JSON
    use Goliath::Rack::Render

    def response(env)
      query = (env['params']['q'] || '') rescue ''
      results = DB::MONGO.db['pages'].find({_keywords: query}, fields: ['title', 'url'])
      [200, {}, results.to_a]
    end
  end
end
