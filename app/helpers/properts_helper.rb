module PropertsHelper
  if $memory.hashValue[:propert].nil?
    newHash = {}
    Propert.all.each do |prop|
      newHash[prop.code.upcase] = prop.value
    end
    $memory.hashValue[:propert] = newHash
  end
  $memory.hashValue[:propert].each do |key, value|
    eval("#{key} = \"#{value}\"")
  end
end
