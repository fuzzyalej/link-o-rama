require_relative '../../config.rb'

class AddNewUrl < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Render

  def response(env)
    url = env['params']['data']
    logger.info "Adding #{url}"
    REDIS.sadd 'urls', url
    [200, {}, url]
  end
end
