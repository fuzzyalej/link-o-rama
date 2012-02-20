# This is mostly a hack to run several processes in a single heroku dyno to check the system online

processes = Hash.new

if processes[:dispatcher] = fork
  puts "Forked the dispatcher"
else
  exec "bundle exec ruby lib/backend/dispatcher.rb -sv"
end

if processes[:server] = fork
  puts "Forked the server"
else
  exec "bundle exec ruby lib/backend/server.rb -sv -e prod -p $PORT"
end
#ADD EACH PROCESS TO REDIS QUEUE FOR STATS AND TO KEEP TRACK
#STATS COUNTER OF WEBS TOO
#PROCESS:DETACH???
handler = Proc.new {
  processes.values.each do |pid|
    Process.kill :TERM, pid
  end
  exit
}

trap(:INT) { handler.call }
trap(:QUIT) { handler.call }
trap(:TERM) { handler.call }

# Keep on waiting for a process to die (the end of the program)
2.times { Process.waitpid -1 }
