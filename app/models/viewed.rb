class Viewed < ApplicationRecord
  def self.fit(arg)
    arg[:agent]=~(/(Googlebot|MJ12bot|AhrefsBot|SemrushBot|AlphaBot|YandexBot|YandexMobileBot|SeznamBot|bingbot|Baiduspider)/) ? true : false
  end
end
