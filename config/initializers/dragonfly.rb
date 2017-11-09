require 'dragonfly'
require 'dragonfly/s3_data_store'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick
  secret "c0ae201052ba1f5fa75c839423975b8adf2401c6fbbf5ae540251fb8d97354d4"

  url_format "/media/:job/:name"

  if ENV["RAILS_ENV"]=="production"
    datastore :s3,
            bucket_name: ENV['bucket'],
            access_key_id: ENV['access_key_id'],
            secret_access_key: ENV['secret_access_key'],
            region: ENV['region'],
            url_scheme: 'https',
            url_host: "https://d2a5jvhcj7z8rz.cloudfront.net"


  else
    datastore :file,
              root_path: Rails.root.join('public/system/dragonfly', Rails.env),
              server_root: Rails.root.join('public')
  end
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
