require 'goliath'
require_relative 'server/add_new_url.rb'

class Server < Goliath::API
  post '/add', AddNewUrl

  def response(env)
    [404, {}, "We don't GET it!"]
  end
end
