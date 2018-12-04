class Job < ApplicationRecord
  include PgSearch
  serialize :preferences, Hash

  after_create :send_email
  before_save :date_close
  include Rails.application.routes.url_helpers
  belongs_to :client
  belongs_to :location
  belongs_to :company
  belongs_to :industry
  has_many :viewed, as: :doc, dependent: :destroy
  has_many :responded, as: :doc, dependent: :destroy

  validates :title, presence: true
  validates :company, presence: true
  validates :location, presence: true
  validates :client, presence: true

  attr_accessor :location_name

  def add_viewed(arg = {})
    if Viewed.fit(arg)
      viewed.create!(arg)
      self.viewed_count ? self.viewed_count += 1 : self.viewed_count=1
      save!
    end
  end

  def add_responded(arg = {})
    responded.create!(arg)
    save!
  end

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


  def to_short_h
    {id:id, title: title, salarymin: salarymin, salarymax: salarymax, description:description, client_id:client_id, company_id:company_id, location_id:location_id, industry_id:industry_id}
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
    text_query << "industry_id = :category" if query[:category].present?
    text_query << "urgent is not null"  if query[:urgent].present?
    if query[:location_id].present?
      text_query << "location_id = :location_id"
    elsif query[:location_name].present?
      locations = Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("|"))
      text_query << "location_id in "+locations.ids.to_s.sub("[","(").sub("]",")") if locations.present?
    end

    text_query << "fts @@ to_tsquery(:value)" if query[:value] != ""


    if  query[:salary].present?
      query[:salary] = query[:salary].to_i
      text_query << '((salarymin>=:salary) or (salarymax >= :salary))'
    end

    text_query = text_query.join(" and ")
    Rails.logger.info("Query::" + text_query + query.to_s)
    select(:id, :title, :location_id, :salarymax, :salarymin, :description, :company_id, :created_at, :updated_at, :highlight,:top,:urgent,:client_id,:close,:industry_id,:twitter, :viewed_count,  "ts_rank_cd(fts,  plainto_tsquery('#{query[:value]}')) AS \"rank\"").where(text_query,query)
  end
end
