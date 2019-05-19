class EmailHr
  include Virtus.model(strict: true)
  include ActiveModel::Model

  attribute :subject
  attribute :fullname
  attribute :email
  attribute :phone
  attribute :location_id
  attribute :location_name
  attribute :industry
  attribute :title
  attribute :description
  attribute :password
  attribute :resume
  attribute :flag

  def save

  end
end