# frozen_string_literal: true

class CreateClientWithJob
  include Virtus.model(strict: true)
  include ActiveModel::Model
  ATTR_NAMES={
      fullname: "Full Name",
      email: "Email",
      location_id: "City",
      title: "Title",
      password: "Password",
      name_of_company: "Name of Company"}
  attribute :fullname
  attribute :email
  attribute :phone
  attribute :location_id
  attribute :location_name
  attribute :title
  attribute :salarymin
  attribute :salarymax
  attribute :description
  attribute :password
  attribute :name_of_company

  validates_each :location_id, :fullname,:email, :title, :password, :name_of_company do |record, attr|
    record.errors.add(attr, "The field '#{ATTR_NAMES[attr]}' can't be blank")
  end

 
  def save
    company = nil
    client = Client.find_by_email(email)
    company = check_client_and_company(client)
    client = validate_client(client) if client.blank?
    company = validate_company(company) if company.blank?
    raise ActiveRecord::RecordInvalid if errors.present?
    Job.transaction do
      company.save! if company.new_record?
      if client.new_record?
        client.company = company
        client.save!
      end
      job = Job.new(
        title: title,
        description: description
      )
    end
  end


  private

  def check_client_and_company(client)
    if client&.company_id
      self.name_of_company = company.name
      company = client.company
    elsif client
      company = Company.find_by_names_or_name(name_of_company)
      if company
        errors.add [:company,  :other, message: "An email Id is not tied to the company. Please, enter a new name of company."]
      end
      self.name_of_company = nil
    else
      nil
    end
  end

  def validate_client(client)
    client = Client.new(
        email: email,
        phone: phone,
        password: password,
        password_confirmation: password,
        location_id: location_id
    )
    client.full_name = fullname
    errors.merge!(client.errors) if client.validate
    client
  end

  def validate_company(company)
    company = Company.new(name: name_of_company, location_id: location_id)
    errors.merge!(company.errors) if company.validate
    company
  end


end
