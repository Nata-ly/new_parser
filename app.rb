puts "What site are we going to parse? (K)arus.ru, (R)arim.ru"
str = gets.strip.capitalize

if str == 'K'
  puts 'K'
elsif str == 'R'
  puts 'R'
else
  puts "You haven't selected anything"
end
