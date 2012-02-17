require 'goliath'
require_relative 'server/add_new_url.rb'

class Server < Goliath::API
  map '/add', AddNewUrl do
    use Goliath::Rack::Validation::RequestMethod, %w(POST)
  end

  def response(env)
    [404, {}, "Bad request"]
  end
end
