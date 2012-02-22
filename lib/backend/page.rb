require_relative 'util/stopwords.rb'

module Linkorama
  class Page
    attr_accessor :title, :keywords

    def initialize(url)
      @url = url
      @title = ''
      @keywords = []
    end

    def keywords=(data)
      data = filter! data
      @keywords = data if data.is_a? Array
    end

    def to_json
      {
        'url' => @url,
        'title' => @title,
        '_keywords' => @keywords
      }
    end

    private

    def filter!(data)
      data.reject!{|word| word.size < 3 }
      data - Linkorama::STOPWORDS
    end
  end
end
