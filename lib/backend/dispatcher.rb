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
        url = REDIS.spop 'urls'
        #do this in a fork
        if url
          #check for maximum fork number here
          if pid = fork
            Process.detach pid
          else
            Worker.new url
          end
          #Check if url already done (in done queue)
          #Spawn webyeur worker/actor to spy on ''url''
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
  end

Dispatcher.new
end
