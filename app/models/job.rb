class Job < ApplicationRecord
  serialize :preferences, Hash

  after_create :send_email
  before_save :date_close
  include Rails.application.routes.url_helpers
  belongs_to :client
  belongs_to :location
  belongs_to :company
  belongs_to :industry

  validates :title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :client, presence: true

  attr_accessor :location_name

  def post_at_twitter(arg)
    twitt = TwitterClient.new
    update(twitter:twitt.update("#{arg} \r\n #{job_url(self, host:PropertsHelper::HOST_NAME)}"))
  end

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

  def self.today_jobs
    Job.where("date_trunc('day',created_at) = date(?)", Time.now)
  end

  def salary
    @salary ||= calc_salary
  end

  def title_capitalize
    @cap ||= self.title.capitalize
  end

  def save
    if self.industry.nil?
      self.industry=Industry.find_by_name('Other')
    end
    if self.company.nil? && self.client.company
      self.company = self.client.company
    end
    super
  end

  def merge(object)
    object1 = self.to_json

  end

  protected

  def send_email
    if self.client.send_email?
      JobsMailer.add_job({mail:self.client.email, firstname: self.client.full_name, id:self.id, title:self.title}).deliver_later
    end
  end

  def date_close
    if self.close.nil?
      self.close = Date.today+1.month
    end
  end

  def calc_salary
    if self.salarymax.blank? and not self.salarymin.blank? then
      '$'+self.salarymin.to_i.to_s
    elsif not (self.salarymax.blank? and self.salarymin.blank? )
      '$'+self.salarymin.to_i.to_s+" - "+ '$'+ self.salarymax.to_i.to_s
    elsif not self.salarymax.blank? and self.salarymin.blank?
      '$'+self.salarymax.to_i.to_s
    else
      ''
    end
  end



  scope :search, ->(query)  do
    query = query.to_h if query.class != Hash
    text_query=[]
    if  not query[:category].blank?
      text_query << "industry_id = :category"
    end

    if not query[:location_id].blank?
      text_query << "location_id = :location_id"
    elsif not query[:location_name].blank?
      locations = Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("&"))
      if not locations.blank?
        text_query << "location_id in "+locations.ids.to_s.sub("[","(").sub("]",")")
      end
    end

    text_query<< "fts @@ to_tsquery(:value)" if query[:value] != ""
    if not query[:salary].blank?
      query[:salary] = query[:salary].to_i
      text_query << '((salarymin is NULL and salarymax >= :salary) or (salarymax is NULL and salarymin>=:salary) or (salarymin <=:salary and salarymax >= :salary))'
    end

    text_query = text_query.join(" and ")

    logger.info("Job::search query = " + text_query + ", params= "+ query.to_s)
    where(text_query,query)
  end


end
