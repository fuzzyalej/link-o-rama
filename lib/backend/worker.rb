module Analynkze
  class Worker
    def initialize(url)
      $PROGRAM_NAME = "Worker-#{url}"
      #add self to redis queue of current workers?
      @url = url
      run!
    end

    def run!
      puts "Parsing #{@url}"
      sleep 10
      #check that url is not in
      # - pending
      # - doing
      # - added
      #connect to url
      #get data
      #format data nicely in an object
      #save object to db
      #save object to indexer
      #add url to parsed
      die!
    end

    def die!
      exit
    end
  end
end
