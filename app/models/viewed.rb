class Viewed < ApplicationRecord
  def self.fit(arg)
    arg[:agent]=~(/(Googlebot|MJ12bot|AhrefsBot|SemrushBot|AlphaBot|YandexBot|YandexMobileBot|SeznamBot|bingbot|Baiduspider|CCBot|Crawler)/) ? true : false
  end
end
