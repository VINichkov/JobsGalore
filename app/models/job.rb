class Job < ApplicationRecord
  belongs_to :location
  belongs_to :company
  #belongs_to :education
  has_many :industry, through: :industryjob
  has_many :skillsjob, dependent: :destroy
  has_many :industryjob, dependent: :destroy
end
