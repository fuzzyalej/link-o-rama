require_relative '../config.rb'
# The dispatcher is always listening on new redis events and
# dispatches them to the workers
class Dispatcher
  def initialize
    listen!
  end

  def listen!
    while 1
      puts REDIS.spop 'url'
      sleep 1
    end
  end
end
