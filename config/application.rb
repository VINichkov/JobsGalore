require_relative 'boot'
require_relative 'single.rb'
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
    end
    config.active_record.schema_format = :sql

    #config.public_file_server.headers = {
     #   'Cache-Control' => 'public, max-age = 604800',
    #    'Expires' => "#{1.year.from_now.to_formatted_s(:rfc822)}"
    #}
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.exceptions_app = self.routes
    #config.action_dispatch.rescue_responses.merge!(
    #    'MyClass::FileNotFound' => :not_found
    #)

  end

end
