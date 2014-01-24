#!/usr/bin/env ruby

require 'json'
require 'nokogiri'
require 'open-uri'

URL = "http://www.reddit.com/r/moosearchive/comments/1hhjnb/archive/"

puts "Getting comment links from: #{URL}"

doc = Nokogiri::HTML(open(URL))

puts "#{doc.css(".usertext-body a").count} links" 

nodes = Array.new

doc.css(".usertext-body a").each do |link|
  begin
    article = Nokogiri::HTML(open(link.content))
    node = OpenStruct.new({})
    node.title = article.css("title").first.content
    node.href = link.content
    nodes << node
  rescue InvalidURIError
    next
  end
end

File.open("moose.json", "w") {|f|
  f.write nodes.to_json
}
