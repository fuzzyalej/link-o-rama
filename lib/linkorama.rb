require 'goliath'
require_relative 'backend/server.rb'
require_relative 'backend/dispatcher.rb'

$PROGRAM_NAME='LOR: Base'
processes = Hash.new

processes[:dispatcher] = fork do
  puts "Starting the dispatcher..."
  Process.setsid
  $PROGRAM_NAME='LOR: Dispatcher'
  Dispatcher.new
end

processes[:server] = fork do
  puts "Starting the server..."
  Process.setsid
  $PROGRAM_NAME='LOR: Server'
  exec "bundle exec ruby lib/backend/server.rb -sv -e prod -p $PORT"
  #Goliath::Application.app_class = 'Server'
  #Goliath::Application.run!
end

$stdout.flush

handler = Proc.new {
  puts "Killing my friends!"
  processes.keys.each do |pid|
    Process.kill "INT", pid
  end
  exit
}

trap(:INT) { handler.call }
trap(:QUIT) { handler.call }
trap(:TERM) { handler.call }
