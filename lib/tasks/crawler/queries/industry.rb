class Industry < Service

def call(*arg)
  puts "Запуск поиска Industry"
  @sql = <<-SQL
              SELECT id as "result"
              FROM sizes
              WHERE name = 'Other'
              LIMIT 1
  SQL
  result = super
  result ? result.to_i : result
end

end