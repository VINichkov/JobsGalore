module PropertsHelper
  Propert.all.each do |prop|
      eval("#{prop.code.upcase} = \"#{prop.value}\"")
  end

end
