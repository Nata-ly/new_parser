require 'nokogiri'
require 'rest-client'
require 'json'

def karus_method
  site_url = "https://karus.ru/program/?city=&adv_type=&search=&letters=&page=&per_page=&preview=true&map=false&per_page=True"
  document = get_nokogiri_document(site_url)
  table = document.at('table.table-data')
  html_array = karus_table_in_array(table)
end

def karus_table_in_array (table,html_array=[])
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
    grp: 'grp' }
  # Deleting the last element in the array.
  html_array.delete_at(html_array.length-1)
  html_array
end

def rarim_method
  site_url = "http://www.rarim.ru/razmeshchenie-reklamy-na-reklamonositelyah/karta-razmeshcheniya/"
  document = get_nokogiri_document(site_url)
  table = document.css('script')
  array = rarim_table_in_array (table)
end

def rarim_table_in_array (table, array=[])
  table.css('script').each do |tr_node|
    if tr_node.to_s.include? "yandexMapsData.push"
      str_node = tr_node.to_s
      index = str_node.index("yandexMapsData.push")+20
      length = str_node.length
      str_node = str_node[index..length]
      length = str_node.index("var catalogRelatedData")-10
      str_node = str_node[0..length]
      response_hash = JSON.parse(str_node)
      hash_objects = response_hash['Objects']
      hash_objects.each_value do |val_objects|
        val_objects.each_value do |val_side|
          val_side.each_value do |val_gid|
            index = 0
            name =''
            val_gid['Properties'].each_value do |val|
              name =  val if index == 3
              index += 1
            end
            hh = { name: name, id: val_gid['Id'], gid: val_gid['Article'],
              sourse_page: val_gid['BigImageSrc'], coords: val_gid['string'] }
            array << hh
          end
        end
      end
    end
  end
  array.unshift(name: "Адрес", id: "Id", gid: "Gid", sourse_page: "Ссылка",
    coords: "Координаты")
  array
end

def get_nokogiri_document(url)
  server = url
  response = RestClient.get(server)
  Nokogiri::HTML(response)
end

puts "What site are we going to parse? (K)arus.ru, (R)arim.ru"
str = gets.strip.capitalize
if str == 'K'
  puts karus_method
elsif str == 'R'
  puts rarim_method
else
  puts "You haven't selected anything"
end
