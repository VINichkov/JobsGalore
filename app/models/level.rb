class Level < ApplicationRecord
  has_many :skillsjob, dependent: :destroy
  has_many :skillsresume, dependent: :destroy
  has_many :languageresume, dependent: :destroy
end
