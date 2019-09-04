class Location < ApplicationRecord

  @@default = nil

  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :experience, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :gateway, dependent: :destroy
  has_many :email_hr, dependent: :destroy


  def name
    @name ||= self.suburb+', '+self.state
  end

  def update_number_of_jobs
    sql = <<-SQL
      update locations as l set counts_jobs = q.counts_jobs
      from (select jobs.location_id, count(jobs.location_id) as counts_jobs
            from jobs
            group by jobs.location_id
      ) q
      where l.id = q.location_id;
    SQL
    ActiveRecord::Base.connection.exec_query(sql)
  end

  protected

  scope :search, ->(query = 'none') {where("locations.fts @@ to_tsquery(:query)",{query:query})}

  def self.major
    #@@major_city ||= select(:id,:suburb).where(suburb:["Sydney", "Melbourne", "Brisbane"]).all
    @major_city = select(:id,:suburb, :counts_jobs).where(suburb:["Sydney", "Melbourne", "Brisbane", "Gold Coast", "Perth", "Adelaide", "Hobart", "Darwin", "Canberra"]).order(counts_jobs: :desc)
  end



  def self.default
    @@default1 ||= find_by_suburb('Sydney')
  end


end
