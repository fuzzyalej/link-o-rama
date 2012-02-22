require 'em-synchrony'
require 'mongo'

module Linkorama
  class DB
    class MONGO
      begin
        uri = ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO'] || 'mongodb://localhost'
        CONN = Mongo::Connection.from_uri(uri, pool_size: 2)
        raise "No database specified" if CONN.nil?
      rescue Exception => e
        puts "Unable to connect to the mongo server: #{e.message}"
      end

      def self.db
        CONN['linkorama']
      end
    end
  end
end
