class Resume < ApplicationRecord
  serialize :preferences, Hash

  belongs_to :client
  belongs_to :location
  belongs_to :industry

  validates :title, presence: true
  validates :location, presence: true

  attr_accessor :ind, :location_name

  alias_attribute  :description,:abouteme
  alias_attribute  :title,:desiredjobtitle
  alias_attribute :salary_form, :salary

  after_create :send_email



  def add_viewed(arg = {})
    viewed.push(arg)
    save!
  end

  def save
    if self.industry.nil?
      self.industry=Industry.find_by_name('Other')
    end
    super
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

  def to_short_h
    {id:id, desiredjobtitle: desiredjobtitle, salary: salary, abouteme:abouteme, client_id:client_id, location_id:location_id, industry_id:industry_id}
  end
  protected

  def send_email
    if self.client.send_email?
      ResumesMailer.add_resume({mail: self.client.email, firstname: self.client.full_name, id: self.id, title: self.title}).deliver_later
    end
  end

  scope :search, ->(query) do
    query = query.to_h if query.class != Hash
    text_query=[]
    if  not query[:category].blank?
      text_query << "industry_id = :category"
    end

    if not query[:location_id].blank?
      text_query << "location_id = :location_id"
    elsif not query[:location_name].blank?
      locations = Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("|"))
      if not locations.blank?
        text_query << "location_id in "+locations.ids.to_s.sub("[","(").sub("]",")")
      end
    end

    text_query<< "fts @@ to_tsquery(:value)" if query[:value] != ""
    if not query[:salary].blank?
      query[:salary] = query[:salary].to_i
      text_query << '(salary <= :salary or salary is NULL)'
    end

    text_query = text_query.join(" and ")

    select(:id, :desiredjobtitle, :location_id, :salary_form, :abouteme, :created_at, :updated_at, :highlight,:top,:urgent,:client_id,:industry_id, "ts_rank_cd(fts,  plainto_tsquery('#{query[:value]}')) AS \"rank\"", :viewed).where(text_query,query)
  end
end
