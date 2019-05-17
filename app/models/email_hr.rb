class EmailHr < ApplicationRecord
  belongs_to :location
  belongs_to :company

  validates :company, presence: true
end