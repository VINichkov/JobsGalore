require 'open-uri'
require 'nokogiri'
require './app/addon/Proxy'
#require 'lightio'
# apply monkey patch at beginning

class CareerOne < Adapter

  def call_remote
    sleep 30
  end

  def treads
    w = []
    10.times do |i|
      w << LightIO::Beam.new{
        a = i
        puts "Поток #{a} старт"
        call_remote
        puts "Поток #{a} конец"
      }
    end
    puts "Все потоки созданы"
    w.each(&:join)
  end

end