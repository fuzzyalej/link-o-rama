require_relative '../config.rb'
require_relative 'worker.rb'

module Analynkze
  # The dispatcher is always listening on new redis events and
  # dispatches them to the workers
  class Dispatcher
    def initialize
      @workers = Array.new
      listen!
    end

    # Maybe this could be an EM.run loop
    def listen!
      while 1
        if url = get_new_url
          #check for maximum fork number here
          if pid = fork
            Process.detach pid
            @workers << pid
          else
            Worker.new url
            #remove pid from workers when done
          end
        end
        sleep 1
      end
    end

    trap(:TERM) do
      @workers.each do |w|
        w.die!
      end
      exit
    end

    private

    def get_new_url
      REDIS.spop 'urls'
    end
  end

  Dispatcher.new
end
