module Linkorama
  # This is a hack to run several processes in a single heroku dyno to check the system online... for free

  processes = Hash.new

  # We fork the class that will act as the dispatcher
  if processes[:dispatcher] = fork
    # the parent goes on
  else
    exec "bundle exec ruby lib/backend/dispatcher.rb -sv"
  end

  # We fork the goliath server that will listen on incoming requests
  if processes[:server] = fork
    # the parent goes on
  else
    exec "bundle exec ruby lib/backend/server.rb -sv -e prod -p $PORT"
  end

  handler = Proc.new do
    processes.values.each do |pid|
      Process.kill :TERM, pid
    end
    exit
  end

  trap(:INT) { handler.call }
  trap(:QUIT) { handler.call }
  trap(:TERM) { handler.call }

  # Keep on waiting for a process to die (the end of the program)
  2.times { Process.waitpid -1 }
end
