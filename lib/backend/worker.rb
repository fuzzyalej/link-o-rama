require 'net/http'
require 'open-uri'
require 'nokogiri'
require_relative 'page'
require_relative 'config/redis'
require_relative 'config/mongo'

module Linkorama
  class Worker
    def initialize(url)
      $PROGRAM_NAME = "Worker-#{url}"
      @url = url
      register_self
      run!
    end

    def run!
      puts "[#{name}] Parsing #{@url}"
      url_not_previously_done or raise "[#{name}] Already done: #{@url}"

      #TODO: Watch out here! if I do a manual POST with '/etc/passwd'... it gets indexed!
      doc = Nokogiri::HTML(open(@url))
      page = Page.new @url
      page.title = doc.css('title').text
      page.keywords = doc.search('//text()').text.downcase.split(/\b+/).sort.uniq

      col = DB::MONGO.db['pages']
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
      DB::REDIS.sismember('lor:done', @url) ? nil : true
    end

    def url_done
      DB::REDIS.sadd('lor:done', @url)
    end

    def register_self
      DB::REDIS.lpush 'lor:workers', Process.pid
    end

    def unregister_self
      DB::REDIS.lrem 'lor:workers', 0, Process.pid
    end

    def name
      "worker-#{Process.pid}"
    end
  end
end
