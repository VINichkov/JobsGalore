arr_word = File.open('qwer.txt').map do |file|
  file
end
a =[]
arr_word.each do |str|
  a += str.split(' ')
end
puts a.count
File.open("1.txt",'w') do |output_file|
  output_file.puts a.uniq
end