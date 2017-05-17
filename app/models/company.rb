class Company < ApplicationRecord
  belongs_to :size
  belongs_to :location
  has_many :job, dependent: :destroy
  has_many :industry ,through: :industrycompany
  has_many :industrycompany, dependent: :destroy
  has_many :responsible, dependent: :destroy
  has_many :client, through: :responsible
  dragonfly_accessor :logo
  validates :name, presence: true
  #validates :location_id, presence: true

  protected

  scope :search, ->(query) do
    text_query = "fts @@ to_tsquery(:value)" if query[:value] != ""
    where(text_query,query)
  end

end
