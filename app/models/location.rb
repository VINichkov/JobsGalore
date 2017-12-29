class Location < ApplicationRecord
  @@major_city=nil

  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :experience, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :gateway, dependent: :destroy
  protected

  scope :search, ->(query) {where("locations.fts @@ to_tsquery(:query)",{query:query})}

  def self.major
    if @@major_city
      @@major_city
    else
      @@major_city = select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane"]).all
      #@@major_city = select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]).all
    end
  end

end
