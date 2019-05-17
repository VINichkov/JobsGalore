class Company < ApplicationRecord
  before_save :rename
  belongs_to :size
  belongs_to :location
  has_many :job, dependent: :destroy
  belongs_to :industry
  has_many :client
  has_many :gateway, dependent: :destroy
  has_many :email_hr, dependent: :destroy

  dragonfly_accessor :logo
  validates :name, presence: true
  # validates :location_id, presence: true
  def full_keywords(count_keys=1 , min_length_word=4)
    if self.name
      array_keywords = []
      array_keywords = self.name&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ')*5
      array_keywords += self.description&.gsub(/[^[:word:]]/,' ')&.downcase&.split(' ')  if self.description
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

  def save
    if self.industry.nil?
      self.industry=Industry.find_by_name('Other')
    end
    if self.site.present?
      if self.site[0..3].downcase != "http"
        self.site = 'http://'+self.site
      end
    end
    super
  end

  def add_name(name)
    self.names.nil? ? self.names = [name] : self.names.push(name)
    self.save
  end

  def self.find_by_names_or_name(name)
    company = self.find_by_names([name])
    company.nil? ? self.find_by_name(name) : company
  end


  protected

  scope :search, ->(query) do
    query = query.to_h if query.class != Hash
    text_query=[]

    text_query << "fts @@ to_tsquery(:value)" if query[:value].present?
    text_query << "industry_id = :category" if  query[:category].present?

    if query[:location_id].present?
      text_query << "location_id = :location_id"
    elsif query[:location_name].present?
      locations = Location.search((query[:location_name].split(" ").map {|t| t=t+":*"}).join("|"))
      text_query << "location_id in "+locations.ids.to_s.sub("[","(").sub("]",")") if locations.present?
    end

    text_query = text_query.join(" and ")

    select(:id, :name, :size_id, :logo_uid, :site, :location_id, :recrutmentagency, :description, :created_at, :updated_at, :realy, :industry_id, "ts_rank_cd(fts,  plainto_tsquery('#{query[:value]}')) AS \"rank\"").where(text_query,query)
  end

  def rename()
    return unless self.logo.present?
    begin
      path_obj = Pathname(self.logo.name)
      self.logo.name = path_obj.sub_ext('').to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + path_obj.extname
    rescue
      logger.fatal "Error: #{$!}"
    end
  end



end
