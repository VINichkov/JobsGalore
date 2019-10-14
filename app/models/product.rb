class Product < ApplicationRecord
  has_many :orders

  def to_str(currency)
    begin
      price[currency.to_s.upcase]['price']
    rescue
      Rails.logger.error('ERROR :Валюта не найдена')
    end
  end

  def to_int(currency)
    begin
      price[currency.to_s.upcase]['price_integer']
    rescue
      Rails.logger.error('ERROR :Валюта не найдена')
    end
  end



end
