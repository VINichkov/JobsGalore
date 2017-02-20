class Language < ApplicationRecord
  has_many :languageresume, dependent: :destroy


end
