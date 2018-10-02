if @response
  json.extract! @response, :title, :industry_id, :location_id, :description
end