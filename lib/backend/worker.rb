require 'net/http'
require 'open-uri'
require 'nokogiri'

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
      #check that url is not in
      # - pending
      # - doing
      # - added
      resp = Net::HTTP.get_response(URI.parse(@url))
      unless resp.code.match(/20\d/)
        raise "Not a valid page: #{resp.code}"
      end
      doc = Nokogiri::HTML(resp.body)
      title = doc.css('title').text
      puts title
      body = doc.search('//text()').text.downcase.gsub(/[^a-z0-9_ á-úñ]/,' ').squeeze.split.sort.uniq
      #filter common stop_words
      #format data nicely in an object
      #save object to db
      #add url to parsed
      die!
    end

    def die!
      exit
    end
  end
end
