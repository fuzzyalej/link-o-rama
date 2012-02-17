require 'goliath'

class Server < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Formatters::JSON
  use Goliath::Rack::Render

  def response(env)
    logger.info env['params']['data']
    [200, {}, 'ok']
  end
end
