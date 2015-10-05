require 'digest'

module Moose

  class StamperService

    def process(array)
      array.map do |entry|
        Stamper.stamp(entry)
      end
    end

    # Creates an identifier on an entry
    # if it doesn't have one
    class Stamper
      def self.stamp(entry, force=false)
        return entry if entry[:id] or entry[:href].nil?
        return entry if entry[:id] and !force
        entry[:id] = Digest::MD5.hexdigest(entry[:href])
        entry
      end
    end

  end

end