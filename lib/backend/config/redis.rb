require 'em-synchrony'
require 'redis'

module Linkorama
  class DB
    REDIS = ::EM::Synchrony::ConnectionPool.new(size: 2) do
      ENV['REDISTOGO_URL'] || ENV['REDIS'] || Redis.new(thread_safe: true)
    end
    raise "Unable to connect to redis server" if REDIS.nil?
  end
end
