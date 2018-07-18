class Company < ApplicationRecord
  before_save :rename
  belongs_to :size
  belongs_to :location
  has_many :job, dependent: :destroy
  belongs_to :industry
  has_many :industrycompany, dependent: :destroy
  has_many :responsible, dependent: :destroy
  has_many :client
  has_many :gateway, dependent: :destroy
  dragonfly_accessor :logo
  validates :name, presence: true
  #validates :location_id, presence: true

  def save
    if self.industry.nil?
      self.industry=Industry.find_by_name('Other')
    end
    if self.site[0..3].downcase != "http" and !self.site.blank?
      self.site = 'http://'+self.site
    end
    super
  end

  protected

  scope :search, ->(query) do
    query = query.to_h if query.class != Hash
    text_query = ''
    text_query = "fts @@ to_tsquery(:value)" if query[:value] != ""

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
