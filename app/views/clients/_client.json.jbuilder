json.extract! client, :id, :firstname, :lastname, :email, :phone, :password, :responsible, :photo, :gender, :location_id, :created_at, :updated_at
json.url client_url(client, format: :json)