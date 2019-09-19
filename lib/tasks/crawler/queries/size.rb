class Size < Service

def call(*arg)
  puts "Запуск поиска Size"
  @sql = <<-SQL
              SELECT id as "result"
              FROM sizes
              LIMIT 1
  SQL
  result = super
  result ? result.to_i : result
end

end