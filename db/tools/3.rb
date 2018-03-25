def first
  puts "the First method"
  "Первый метод"
end

def second
  puts "the Second method"
  "Второй метод"
end

def go
  a = Hash.new(first: send(:first), second: send(:second))
  puts a[:first]
end

go