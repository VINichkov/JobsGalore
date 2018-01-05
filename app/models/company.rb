class Company < ApplicationRecord
  before_save :rename
  belongs_to :size
  belongs_to :location
  has_many :job, dependent: :destroy
  has_many :industry ,through: :industrycompany
  has_many :industrycompany, dependent: :destroy
  has_many :responsible, dependent: :destroy
  has_many :client, through: :responsible
  has_many :gateway, dependent: :destroy
  dragonfly_accessor :logo
  validates :name, presence: true
  #validates :location_id, presence: true

  def logo_url
    if @logo_url
      @logo_url
    else
      @logo_url = self.logo_uid ? Dragonfly.app.remote_url_for(object.logo_uid) : image_url("company_profile.jpg")
    end
  end
  protected

  scope :search, ->(query) do
    text_query = "fts @@ to_tsquery(:value)" if query[:value] != ""
    where(text_query,query)
  end

  def rename()
    return unless self.logo.present?
    path_obj = Pathname(self.logo.name)
    self.logo.name = path_obj.sub_ext('').to_s.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + path_obj.extname
  end



end
