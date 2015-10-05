module Moose
  class TitleParser
    def self.parse(link)
      title = get_title_for link
      title.gsub! /\s+/, " "
      title.strip!
      title
    end

    def self.get_title_for(link)
      link = "http://#{link}" unless link.start_with? "http://"
      body = Nokogiri::HTML(open(link, :allow_redirections => :safe))
      body.css("head title").first.content
    end
  end
end
