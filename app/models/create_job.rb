# frozen_string_literal: true

class CreateJob
  include Virtus.model(strict: true)
  include ActiveModel::Model
  ATTR_NAMES={
      email: "Email",
      location_id: "City",
      title: "Title",
      password: "Password",
      company_name: "Company name"}
  attribute :email
  attribute :location_id
  attribute :location_name
  attribute :title
  attribute :salarymin
  attribute :salarymax
  attribute :description
  attribute :password
  attribute :company_name

  validates_each  :email, :password  do |record, attr, value|
    record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank") if value.blank?
  end if

  validates_each :company_name , on: [:save_first_time, :save_job_from_applicant]  do |record, attr, value|
    record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank") if value.blank?
    record.errors.add(:base, "This company name is already in use") if Company.find_by_name(value).present?
  end

  validates_each :location_id, :title,  on: :save do |record, attr, value|
    record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank") if value.blank?
  end

  validates_each :email, on: :save_first_time do |record, attr, value|
    record.errors.add(:base, "This email address is already in use") if Client.find_by_email(value).present?
  end

  def save(user)
      begin
        Job.transaction do
          if user.blank?
            save_first_time
          elsif user.applicant?
            save_job_from_applicant(user)
          else
            save_job_from_employer(user)
          end
        end
      rescue
        false
      end
    end

  private

  def save_first_time
    company = create_company
    client = create_client(company)
    create_job(company, client)
  end

  def save_job_from_applicant(user)
    company = create_company
    update_client(user, company)
    create_job(company, user)
  end

  def save_job_from_employer(user)
    create_job(user&.company, user)
  end

  def create_client(company)
    Client.new(
        firstname: email,
        email: email,
        phone: phone,
        character: TypeOfClient::EMPLOYER,
        password: password,
        password_confirmation: password,
        location_id: location_id,
        company: company
    )
  end

  def update_client(user, company)
   user.update(character: TypeOfClient::EMPLOYER, company: company)
  end

  def create_company
    Company.create!(name: company_name, location_id: location_id)
  end

  def create_job(company, client)
    Job.create!(
        title: title,
        description: description,
        salarymin: salarymin,
        salarymax: salarymax,
        location_id: location_id,
        company: company,
        client: client
  )
  end

end
