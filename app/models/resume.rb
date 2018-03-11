class Resume < ApplicationRecord
  belongs_to :client
  belongs_to :location
  belongs_to :industry

  validates :title, presence: true
  validates :location, presence: true

  attr_accessor :ind, :location_name

  alias_attribute  :description,:abouteme
  alias_attribute  :title,:desiredjobtitle
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
  protected

  scope :search, ->(query) do
    query = query.to_h if query.class != Hash
    text_query=[]
    if  not query[:category].blank?
      text_query << "industry_id = :category"
    end

    if not query[:location_id].blank?
      text_query << "location_id = :location_id"
    elsif not query[:location_name].blank?
      text_query << "location_id in "+Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("&")).ids.to_s.sub("[","(").sub("]",")")
    end

    text_query<< "fts @@ to_tsquery(:value)" if query[:value] != ""
    if not query[:salary].blank?
      query[:salary] = query[:salary].to_i
      text_query << '(salary <= :salary or salary is NULL)'
    end

    text_query = text_query.join(" and ")

    logger.info("Resume::search query = " + text_query + ", params= "+ query.to_s)
    where(text_query,query)
  end
end
