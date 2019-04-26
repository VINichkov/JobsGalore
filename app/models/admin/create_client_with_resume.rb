# frozen_string_literal: true

class Admin::CreateClientWithResume
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

  def save
    Rails.logger.debug "phone = #{phone}, email = #{email}, (phone || email) = #{(phone || email)}"
    self.password = phone.present? ? phone : email
    client = Client.new(
      email: email,
      phone: phone,
      password: password,
      password_confirmation: password,
      location_id: location_id
    )
    client.full_name = fullname
    if client.save
      self.resume = Resume.new(
        title: title,
        description: description,
        location_id: location_id,
        industry_id: industry,
        client: client
      )
      if resume.save
        params = {
          name: client.firstname,
          email: email,
          password: password
        }
        OtherMailer.the_resume_has_posted(email, "RE: #{subject}", params).deliver_later
      else
        errors.merge!(resume.errors)
      end
    else
      errors.merge!(client.errors)
    end
    errors.blank?
  end
end
