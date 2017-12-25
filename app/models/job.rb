class Job < ApplicationRecord
  belongs_to :client
  belongs_to :location
  belongs_to :company
  #belongs_to :education
  has_many :industry, through: :industryjob
  #has_many :skillsjob, dependent: :destroy
  has_many :industryjob, dependent: :destroy
  validates :title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :client, presence: true

  attr_accessor :ind, :location_name

  def highlight_on
    self.highlight = Date.today
    self.save
  end
  def urgent_on
    self.urgent = Date.today
    self.save
  end
  def top_on
    self.top = Date.today
    self.save
  end
  def highlight_off
    self.highlight = nil
    self.save
  end
  def urgent_off
    self.urgent = nil
    self.save
  end
  def top_off
    self.top = nil
    self.save
  end

  def self.delete_jobs
    self.where('close<date(?)',Time.now).destroy_all
  end

  def self.delete_jobs_of_today
    Job.where("date_trunc('day',created_at) = date_trunc('day',?)", Time.now)
  end

  protected

  scope :search, ->(query)  do
    text_query = []
    if  not(query[:category].nil?) and not (query[:category]=="999") then
      text_query << "id in "+Industryjob.where(industry:query[:category]).pluck(:job_id).to_s.sub("[","(").sub("]",")")
    end
    if  (not query[:location_id].nil?) and (not query[:location_id] == "")
      text_query << "location_id = :location_id"
    elsif ((not (query[:location_name].nil?) and not(query[:location_name]== "")) and (query[:location_id].nil? or query[:location_id] == ""))
      text_query << "location_id in "+Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("&")).ids.to_s.sub("[","(").sub("]",")")
    end
    text_query << 'urgent  is not null'  if (query[:urgent] == "on")
    text_query << 'permanent  = true'  if (query[:permanent] == "on")
    text_query << 'casual  = true'     if (query[:casual] == "on")
    text_query << 'temp  = true'       if (query[:temp] == "on")
    text_query << 'contract  = true'   if (query[:contract] == "on")
    text_query << 'fulltime  = true'   if (query[:fulltime] == "on")
    text_query << 'parttime  = true'   if (query[:parttime] == "on")
    text_query << 'flextime = true'    if (query[:flextime] == "on")
    text_query << 'remote  = true'     if (query[:remote] == "on")
    text_query<< "fts @@ to_tsquery(:value)" if query[:value] != ""
    if (not query[:salary].nil?) and (not query[:salary]=="")
      text_query << '((salarymin is NULL and (salarymax >= :salary or salarymax is NULL)) or (salarymin>=:salary) or (salarymin <=:salary and salarymax >= :salary))'
    end
    text_query = text_query.join(" and ")
    puts "________________________________"
    puts text_query
    where(text_query,query)
  end


end
