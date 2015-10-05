module Moose

  class TagService

    def initialize(taglist)
      @taglist = taglist
    end

    def process(array)
      array.map do |entry|
        Tagger.tag(@taglist, entry)
      end
    end

    class Tagger
      def self.tag(taglist, entry)
        return entry if entry[:title].nil?
        entry[:tags] = []
        
        title = entry[:title]
        taglist.each do |tag|
          entry[:tags] << tag if title.include? tag
        end

        entry
      end
    end

  end

end