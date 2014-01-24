#!/usr/bin/env ruby

require 'json'
require 'nokogiri'
require 'open-uri'
require './moose/title_parser'

URL = "http://www.reddit.com/r/moosearchive/comments/1hhjnb/archive/"
MD_FILE = "./moose.md"
JSON_FILE = "./moose.json"

puts "Getting comment links from: #{URL}"

doc = Nokogiri::HTML(open(URL))
nodes = []
File.open("unreachable.txt","w") {|f| f.write "" }

puts "#{doc.css(".usertext-body a").count} links" 

doc.css(".usertext-body a").each do |link|
  begin
    title = Moose::TitleParser.parse(link.content)

    nodes << {
      :title => title,
      :href  => link.content
    }

    unless File.read(MD_FILE).include? link.content
      File.open(MD_FILE, "a") do |f|
        f.puts "[#{title}](#{link.content})"
      end
    end

    puts "Added: #{link.content}"
  rescue => e
    STDERR.puts "Failed: #{link.content} (#{e.class.name}: #{e.message})"
    File.open("unreachable.txt","a") {|f| f.puts "#{link.content};#{e.class.name};#{e.message}" }
    next
  end
end

File.open(JSON_FILE, "w") {|f|
  f.write nodes.to_json
}

