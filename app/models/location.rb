class Location < ApplicationRecord

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
    locations = {"Sydney":0, "Melbourne":1, "Brisbane":2, "Gold Coast":3, "Perth":4, "Adelaide":5, "Hobart": 6,"Darwin":7, "Canberra":8}
    arr = []
    #@@major_city ||= select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane"]).all
    select(:id,:suburb,:counts_jobs).where(suburb:locations.keys).each do |t|
      arr[locations[:"#{t.suburb}"]] = t
    end
    arr
  end



  def self.default
    @@default1 ||= find_by_suburb('Sydney')
  end


end
