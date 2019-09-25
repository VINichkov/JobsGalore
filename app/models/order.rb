class Order < ApplicationRecord
  belongs_to :algorithm
  belongs_to :product
  belongs_to :payment

end
