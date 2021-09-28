require 'nokogiri'
require 'rest-client'

def karus_method
  server = "https://karus.ru/program/?city=&adv_type=&search=&letters=&page=&per_page=&preview=true&map=false&per_page=True"
  response = RestClient.get(server)
  document = Nokogiri::HTML(response)
  table = document.at('table.table-data')
end

puts "What site are we going to parse? (K)arus.ru, (R)arim.ru"
str = gets.strip.capitalize

if str == 'K'
  karus_method
elsif str == 'R'
  puts 'R'
else
  puts "You haven't selected anything"
end
