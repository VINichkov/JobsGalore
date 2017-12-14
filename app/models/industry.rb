class Industry < ApplicationRecord
  @@all_cache=nil
  has_many :industryexperience, dependent: :destroy
  has_many :industrycompany, dependent: :destroy
  has_many :company, through: :industrycompany
  has_many :industryjob, dependent: :destroy
  has_many :job, through: :industryjob
  has_many :industryresume, dependent: :destroy
  has_many :resumes, through: :industryresume
  has_many :gateway, dependent: :destroy

  has_many :lower,  class_name: "Industry", dependent: :destroy

  has_one :industry, class_name: "Industry"

  def self.all
    @@all_cache ? @@all_cache : @@all_cache=super
  end
end
