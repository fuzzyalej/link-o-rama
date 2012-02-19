require 'goliath'
require 'redis'

REDIS = ::EM::Synchrony::ConnectionPool.new(size: 2) do
    ENV['REDISTOGO_URL'] || ENV['REDIS'] || Redis.new
end
raise "Unable to connect to redis server" if REDIS.nil?
puts REDIS.inspect
