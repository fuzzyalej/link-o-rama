require 'goliath'
require_relative '../config/redis.rb'
module Linkorama
  class AddNewUrl < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::Formatters::JSON
    use Goliath::Rack::Render

    def response(env)
      url = env['params']['data']
      logger.info "[goliath] Adding #{url}"
      DB::REDIS.sadd 'urls', url
      [200, {}, url]
    end
  end
end
