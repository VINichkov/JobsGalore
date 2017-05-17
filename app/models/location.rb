class Location < ApplicationRecord


  has_many :client, dependent: :destroy
  has_many :company, dependent: :destroy
  has_many :job, dependent: :destroy
  has_many :experience, dependent: :destroy
  has_many :resume, dependent: :destroy
  has_many :children, class_name: "Location",
           foreign_key: "parent_id"
  belongs_to :parent, class_name: "Location"
  protected

  scope :search, ->(query) {where("locations.fts @@ to_tsquery(:query)",{query:query})}

end
