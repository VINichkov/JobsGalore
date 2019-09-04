class CreatorsJob::CreateJobParent
  include Virtus.model(strict: true)
  include ActiveModel::Model

  ATTR_NAMES={
      location_id: "City",
      title: "Title",
  }


  attribute :location_id
  attribute :location_name
  attribute :title
  attribute :description

  validates_each :location_id, :title do |record, attr, value|
    record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank") if value.blank?
  end


end