require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Mongo
  class Application < Rails::Application
    config.before_configuration do
      env_aws = Rails.root.join("config", 'asset_sync.yml').to_s
      if File.exists?(env_aws)
        YAML.load_file(env_aws)[Rails.env].each do |key, value|
          ENV[key.to_s] = value
        end
      end
      env_aws = Rails.root.join("config", 'options.yml').to_s
      if File.exists?(env_aws)
        YAML.load_file(env_aws)[Rails.env].each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end
    config.active_record.schema_format = :sql
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.exceptions_app = self.routes
  end
end
