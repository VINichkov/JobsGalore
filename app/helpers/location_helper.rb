module LocationHelper
  def link_location(name = nil, location = nil, type= nil, html_options = nil, &block)
    link_to name , "/in_location/#{location.id}/#{type.code}", html_options, &block
  end
end