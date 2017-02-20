class Languageresume < ApplicationRecord
  belongs_to :resume
  belongs_to :language
  belongs_to :level
end
