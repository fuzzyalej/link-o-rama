require_relative 'worker.rb'
require_relative 'config/redis.rb'

module Linkorama
  # The dispatcher is always listening on new redis events and
  # dispatches them to the workers
  class Dispatcher
    def initialize
      puts "[#{name}] Starting dispatcher"
      $stdout.flush
      listen!
    end

    # Maybe this could be an EM.run loop
    def listen!
      EM.run do
        EM.add_periodic_timer(1) do
          if url = get_new_url
            puts "[#{name}] Reading #{url}"
            #check for maximum fork number here
            if pid = fork
              Process.detach pid
            else
              Worker.new url
            end
          end
        end
      end
    end

    trap(:TERM) do
      workers.each do |w|
        w.die!
      end
      exit
    end

    private

    def workers
      DB::REDIS.lrange 'lor:workers', 0, -1
    end

    def get_new_url
      DB::REDIS.spop 'lor:urls'
    end

    def name
      "Dispatcher-#{Process.pid}"
    end
  end

  Dispatcher.new
end
