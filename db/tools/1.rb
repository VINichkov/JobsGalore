arr_word = [1,2,3,4,5,6,7,8,9,10,11,12,14]
a = rand(15).times.map do
  puts 'q'
  arr_word.sample.to_s.delete("\n")+' '
end

puts a.join()