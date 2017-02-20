class Resume < ApplicationRecord
  belongs_to :client
  has_many :experience, dependent: :destroy
  has_many :skillsresume, dependent: :destroy
  has_many :industryresume, dependent: :destroy
  has_many :languageresume, dependent: :destroy
  has_many :industry, through: :industryresume
  has_many :language, through: :languageresume

end
