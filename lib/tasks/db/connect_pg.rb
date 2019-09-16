require 'yaml'
require 'pg'
# require "#{Rails.root}/lib/tasks/db/connect_pg.rb"
class ConnectPg
  attr_accessor :connect
  def initialize
    ENV['RAILS_ENV'] ||= 'development'
    config = YAML.load_file("#{Rails.root}/config/database.yml")[ENV['RAILS_ENV']]
    @connect = PG.connect(
      dbname: config['database'],
      user: config['username'],
      password: config['password']
    )
  end
end