require 'goliath'
require_relative 'server/add_new_url.rb'
require_relative 'server/search.rb'

module Linkorama
  class Server < Goliath::API
    post '/add', AddNewUrl
    get '/search', Search

    use(Rack::Static,
       root: Goliath::Application.app_path('../frontend'),
       urls: ['/favicon.ico', '/index.html', '/includes', '/lib'])

    def response(env)
      [404, {}, "We don't GET it!"]
    end
  end
end
