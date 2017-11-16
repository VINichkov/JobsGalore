class Gateway < ApplicationRecord
  includes Monash
  belongs_to :company
  belongs_to :client
  belongs_to :location
  belongs_to :industry

  validates :company, presence: true
  validates :client, presence: true
  validates :industry, presence: true
  validates :location, presence: true
  validates :script, presence: true

  def execute
    @qwer = Monash.new
  end

  def read
    @qwer.read
  end

end
