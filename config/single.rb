require 'singleton'
class Single
  include Singleton
  attr_accessor :mem
  $mem
end