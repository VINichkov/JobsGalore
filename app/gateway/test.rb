$LOAD_PATH.unshift File.expand_path('..', __FILE__)
require 'conf'
a = Monash.new
puts a.read
