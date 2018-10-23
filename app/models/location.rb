class Location < ApplicationRecord

  @@major_city=nil
  @@default = nil

  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :experience, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :gateway, dependent: :destroy


  def name
    @name ||= self.suburb+', '+self.state
  end

  protected

  scope :search, ->(query) {where("locations.fts @@ to_tsquery(:query)",{query:query})}

  def self.major
    @@major_city ||= select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane"]).all
      #@@major_city = select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]).all
  end



  def self.default
    @@default1 ||= find_by_suburb('Sydney')
  end


end
