class Industry < ApplicationRecord
  @@all_cache=nil
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :gateway, dependent: :destroy

  def self.all
    @@all_cache ||=super
  end
end
