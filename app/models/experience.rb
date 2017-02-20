class Experience < ApplicationRecord
  belongs_to :location
  belongs_to :resume
  has_many :industry, through: :industryexperience
  has_many :industryexperience, dependent: :destroy

end
