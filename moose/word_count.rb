module Moose
  class WordCount
    def initialize(json)
      @json = json
      @words = {}
    end
    
    def process
      @json.each do |node|
        node.title.split.each do |word|
          increment word
        end
      end
      @words
    end

    def increment(word)
      if @words.keys.include? word
        @words[word]++
      else
        @words[word] = 1
      end
    end

  end
end
