class Location < ApplicationRecord

  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :email_hr, dependent: :destroy

  def name
    self.suburb + ', ' + self.state
  end

  private

  scope :search, ->(query = 'none') {where("locations.fts @@ to_tsquery(:query)",{query:query})}

  def self.major
    select(:id,:suburb, :counts_jobs).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]).order(counts_jobs: :desc)
  end


  def self.default
    find_by_suburb('Sydney')
  end

end
