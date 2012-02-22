require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'mongo'
require_relative 'page'

module Analynkze
  class Worker
    def initialize(url)
      $PROGRAM_NAME = "Worker-#{url}"
      @url = url
      register_self
      run!
    end

    def run!
      puts "Parsing #{@url}"
      #check that url is not in
      # - pending
      # - doing
      # - added
      url_not_previously_done or raise "#Already done: #{@url}"

      doc = Nokogiri::HTML(open(@url))
      page = Page.new @url
      page.title = doc.css('title').text
      page.keywords = doc.search('//text()').text.downcase.scan(/\w+/).sort.uniq

      #Objectize the DB access
      db = Mongo::Connection.new.db('linkorama')
      col = db['pages']
      col.insert(page.to_json)

      url_done
      die!
    rescue Exception => e
      die! e.message
    end

    def die!(msg=nil)
      puts msg if msg
      unregister_self
      exit
    end

    private

    def url_not_previously_done
      REDIS.sismember('done', @url) ? nil : true
    end

    def url_done
      REDIS.sadd('done', @url)
    end

    def register_self
      REDIS.lpush 'workers', Process.pid
    end

    def unregister_self
      REDIS.lrem 'workers', 0, Process.pid
    end
  end
end
