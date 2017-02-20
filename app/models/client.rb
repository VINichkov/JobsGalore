class Client < ApplicationRecord
  belongs_to :location
  has_many :resume, dependent: :destroy
  has_many :responsible, dependent: :destroy
  has_many :company, through: :responsible


end
