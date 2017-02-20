class Company < ApplicationRecord
  belongs_to :size
  belongs_to :location
  has_many :job, dependent: :destroy
  has_many :industry ,through: :industrycompany
  has_many :industrycompany, dependent: :destroy
  has_many :responsible, dependent: :destroy
  has_many :client, through: :responsible

end
