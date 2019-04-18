class Job < ApplicationRecord
  SHELF_LIFE = 15
  include PgSearch
  serialize :preferences, Hash

  after_create :send_email_after_add_job
  before_destroy :send_email_before_destroy
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

  def full_keywords(count_keys=1 , min_length_word=4)
    if self.title
      array_keywords = []
      array_keywords = self.title&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ')*5
      if self.description
        desc = HtmlToPlainText.plain_text(self.description)
        desc = Search.str_to_search(desc)&.squish
        array_keywords += desc&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ')
      end
      array_keywords.compact!
      index_hash = {}
      array_keywords.each do |word|
        if word.length>min_length_word
          index_hash[word] ?  index_hash[word] +=1 : index_hash[word]=1
        end
      end
      array_keywords = []
      index_hash.each do |key, value|
        array_keywords << {key => value}
      end
      array_keywords.sort{|x, y| y.values[0]<=> x.values[0]}[0..count_keys-1].map{|t| t.keys.first}
    end
  end

  def add_viewed(arg = {})
    unless Viewed.fit(arg)
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
    turn_on_option("Highlight")
  end

  def urgent_on
    self.urgent = Date.today
    self.save
    turn_on_option("Urgent")
  end
  def top_on
    self.top = Date.today
    self.save
    turn_on_option("Top")
  end
  def highlight_off
    self.highlight = nil
    self.save
    turn_off_option("Highlight")
  end
  def urgent_off
    self.urgent = nil
    self.save
    turn_off_option("Urgent")
  end
  def top_off
    self.top = nil
    self.save
    turn_off_option("Top")
  end

  def self.delete_jobs
    self.where('close<date(?)',Time.now).destroy_all
  end

  def self.today_jobs
    Job.where("date_trunc('day',created_at) = date(?)", Time.now)
  end

  def days_before_сlose
    @date_now ||= Time.now.to_date
    (self.dt_close - @date_now).to_i
  end

  def dt_close
    [self.close, self.urgent, self.top, self.highlight].compact.max
  end

  def can_prolong?
    days= self.days_before_сlose
    days <= 2 ? days : false
  end

  def prolong
    self.close =  Time.now + 14.days
    Rails.logger.debug("Проведена пролонгация записи #{self.title} - #{self.id}")
    self.save
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

  def self.automatic_create(**job)
    old_company = true
    company = Company.find_by_names_or_name(job[:company])
    if company.nil?
      company = Company.create(name:job[:company], size: Size.first, location_id: job[:location], industry_id: job[:industry])
      old_company = false
    end
    company.job.where(title: job[:title], location_id: job[:location]).destroy_all if old_company
    user = company.client.first
    if user.blank?
      email = "#{job[:company].delete("<>{}#@!,.:*&()'`\"’").gsub(' ', '_')}#{(0...8).map {(97 + rand(25)).chr}.join}@email.com.au"
      puts email
      user = Client.new(firstname: job[:company], lastname: 'HR', email: email, location_id: job[:location], character: TypeOfClient::EMPLOYER, send_email: false, password: '11111111', password_confirmation: '11111111', company_id: company.id)
      user.skip_confirmation! if Rails.env.production?
      user.save!
    end
    Rails.logger.debug "Сохраняем #{job[:title]}  в #{job[:location]}"
    Job.create!(title: job[:title],
                location_id: job[:location],
                salarymin: job[:salary_min],
                salarymax: job[:salary_max],
                description: job[:description],
                company: company,
                client: user,
                sources: job[:link],
                apply: job[:apply])
  end

  protected

  def send_email_after_add_job
    if self.client.send_email
      JobsMailer.add_job(self ).deliver_later
      JobsMailer.add_job(self, true).deliver_later
    end
  end

  def send_email_before_destroy
    if self.client.send_email
      JobsMailer.remove_job(self).deliver_later
    end
  end

  def turn_on_option(option)
    if self.client.send_email
      JobsMailer.turn_on_option(option, self).deliver_later
    end
  end

  def turn_off_option(option)
    if self.client.send_email
      JobsMailer.turn_off_option(option, self).deliver_later
    end
  end

  def date_close
    if self.close.nil?
      self.close = Date.today+SHELF_LIFE.days
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

  scope :search_for_send, ->(**arg) do
    text_query=[]
    query={date:Time.now - 1.days}
    if arg[:location]
      text_query<<"location_id = :location"
      query[:location] =  arg[:location]
    end
    text_query << "created_at >= :date"
    text_query << "fts @@ to_tsquery(:value)"
    query[:value] = arg[:value].split(" ").map{|t| t=t+":*"}.join("|")
    text_query = text_query.join(" and ")
    select(:id, :title, :location_id, :salarymax, :salarymin, :description, :company_id, :created_at, :updated_at, :highlight,:top,:urgent,:client_id,:close,:industry_id,:twitter, :viewed_count,  "ts_rank_cd(fts,  to_tsquery('#{query[:value]}')) AS \"rank\"").where(text_query,query).order('rank DESC').limit(10).to_a
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
    select(:id, :title, :location_id, :salarymax, :salarymin, :description, :company_id, :created_at, :updated_at, :highlight,:top,:urgent,:client_id,:close,:industry_id,:twitter, :viewed_count,  "ts_rank_cd(fts,  to_tsquery('#{query[:value]}')) AS \"rank\"").where(text_query,query)
  end
end
