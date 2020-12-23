#---
# Excerpted from "Seven Databases in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/pwrdata for more book information.
#---
require 'bloomfilter-rb'

bloomfilter = BloomFilter::Redis.new(:size => 1000000)
bloomfilter.clear

# we'll read the file data and strip out all the non-word material
text_data = File.read(ARGV[0])
clean_text = text_data.gsub(/\n/, ' ').gsub(/[,-.;'?"()!*]/, '')

clean_text.split(' ').each do |word|
  word = word.downcase

  next if bloomfilter.include?(word)
  puts word
  bloomfilter.insert(word)
end

puts "Total number of words: #{text_data.length}"
puts "Number of words in filter: #{bloomfilter.size}"
