require 'yaml'
require 'pg'
# require "#{Rails.root}/lib/tasks/db/connect_pg.rb"
class ConnectPg
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
    puts "config['database'] = #{config['database']}"
    puts "config['database'] = #{config['username']}"
    puts "config['database'] = #{config['password']}"
    @connect = PG.connect(
      dbname: config['database'],
      user: config['username'],
      password: config['password']
    )
  end
end