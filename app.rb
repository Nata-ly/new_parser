require 'nokogiri'
require 'rest-client'

def karus_method
  site_url = "https://karus.ru/program/?city=&adv_type=&search=&letters=&page=&per_page=&preview=true&map=false&per_page=True"
  document = get_nokogiri_document(site_url)
  table = document.at('table.table-data')
  html_array=[]
  table.css('tr').each do |tr_node|
    array = []
    tr_node.css('td').each_with_index do |td, index|
      array << td.text
      if  index == 3
        td.css('a').map { |link|  array << link['href'] }
      end
    end
    sourse_page = 'https://karus.ru' + array[4].to_s
      hh = { adress: array[0], side: array[1], backlight: array[2],
        gid: array[3], sourse_page: sourse_page, town: array[5],
        grp: array[6] }
      html_array << hh
  end
  html_array[0]={ adress: 'Адрес', side: 'Сторона', backlight: 'Подсветка',
    gid: 'Гид', sourse_page: 'Ссылка', town: 'Город',
    grp: 'grp'}
  # Deleting the last element in the array.
  html_array.delete_at(html_array.length-1)
  html_array
end

def get_nokogiri_document(url)
  server = url
  response = RestClient.get(server)
  Nokogiri::HTML(response)
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
