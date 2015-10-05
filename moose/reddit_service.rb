require 'open-uri'

module Moose
  class RedditService

    def process(array)
      array.map do |entry|
        begin
          RedditLinker.link(entry)
        rescue
          entry
        end
      end
    end

    class RedditLinker
      def self.link(entry)
        return entry if entry[:reddit] and entry[:href] != entry[:reddit]

        uri = URI.parse(entry[:href])
        return entry unless uri.host.include? "reddit.com"

        entry[:reddit] = entry[:href]
        json = JSON.parse(open(entry[:reddit]), {symbolize_names: true})
        url = json.first[:data][:children].first[:data][:url]
        URI.parse(url)

        entry[:href] = url

        entry
      end
    end

  end
end