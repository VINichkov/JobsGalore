require 'yaml'
require 'pg'
require 'singleton'

# require "#{Rails.root}/lib/tasks/db/connect_pg.rb"
class ConnectPg
  include Singleton

  attr_accessor :connect
  def initialize
    if ENV['RAILS_ENV'] == 'production'
      config = YAML.load_file("#{Rails.root}/config/database.yml")[ENV['RAILS_ENV']]
      conf_app = YAML.load_file("#{Rails.root}/config/application.yml")[ENV['RAILS_ENV']]
      config['username'] = conf_app['MONGO_DATABASE_USER']
      config['password'] = conf_app['MONGO_DATABASE_PASSWORD']
    else
      ENV['RAILS_ENV'] ||= 'development'
      config = YAML.load_file("#{Rails.root}/config/database.yml")[ENV['RAILS_ENV']]
    end
    @connect = PG.connect(
      host: 'localhost',
      dbname: config['database'],
      user: config['username'],
      password: config['password']
    )

  end
end