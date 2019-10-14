class Country
  def self.currency_by_country(ip)
    country = Geocoder.search(ip).first.country
    country_in_system = {
        'IN': :INR,
        'AU': :AUD,
        'US': :USD,
        'CA': :CAD,
        'AT': :EUR,
        'BE': :EUR,
        'DE': :EUR,
        'GD': :EUR,
        'IE': :EUR,
        'ES': :EUR,
        'IT': :EUR,
        'CY': :EUR,
        'LV': :EUR,
        'LB': :EUR,
        'LU': :EUR,
        'MT': :EUR,
        'NL': :EUR,
        'PT': :EUR,
        'SK': :EUR,
        'SI': :EUR,
        'FI': :EUR,
        'FR': :EUR,
        'EE': :EUR,
        'UK': :GBR,
        'RU': :RUB,
        'CN': :CNT,
        any: :AUD
    }
    result = country_in_system[country]
    country_in_system[:any] if result.nil?
  end
end
