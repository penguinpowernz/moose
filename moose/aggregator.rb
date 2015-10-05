require 'json'

module Moose
  class Aggregator

    def process(array)
      counts   = {}
      mappings = {}
      indexes  = []

      array.each do |entry|
        counts   = Counter.count(entry, counts)
        mappings = Mapper.map(entry, mappings)
        indexes << entry[:id]
      end

      File.write("wordcounts.json",   counts.to_json)
      File.write("tag_mappings.json", mappings.to_json)
      File.write("indexes.json",      indexes.to_json)

      array
    end

    class Counter
      def self.count(entry, counts)
        return counts if entry[:tags].empty?

        entry[:tags].each do |tag|
          if counts[tag]
            counts[tag]+= 1 
          else
            counts[tag] = 1
          end
        end

        counts
      end
    end

    class Mapper
      def self.map(entry, mappings)
        return mappings if entry[:tags].empty?

        entry[:tags].each do |tag|
          if mappings[tag]
            mappings[tag] << entry 
          else
            mappings[tag] = [entry]
          end
        end

        mappings
      end
    end
    
  end
end
