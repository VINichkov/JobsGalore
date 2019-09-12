# frozen_string_literal: true

class CreateJob

  include Virtus.model(strict: true)
  include ActiveModel::Model
  ATTR_NAMES={
      email: "Email",
      location_id: "City",
      title: "Title",
      full_name: "Full name",
      password: "Password",
      company_name: "Company name"}
  attribute :type, Symbol, default: :first_time
  attribute :full_name
  attribute :email
  attribute :location_id
  attribute :location_name
  attribute :title
  attribute :salarymin
  attribute :salarymax
  attribute :description
  attribute :password
  attribute :company_name

  #validates :location_id, :title, presence: {message: "The field '#{ATTR_NAMES[attr]}' can't be blank"}
  #validates :company_name , presence: {message: "The field '#{ATTR_NAMES[attr]}' can't be blank"} unless is_employer?
  #validates :full_name, :email, :password, presence: {message: "The field '#{ATTR_NAMES[attr]}' can't be blank"} if first_time?


  validates_each  :full_name, :email, :password  do |record, attr, value|
    if value.blank? && (record.type == :first_time || record.type == :is_applicant)
      record.errors.add(:base, "The field '#{ATTR_NAMES[attr]}' can't be blank")
    end
    if attr == :company_name && Company.find_by_name(value).present?
      record.errors.add(:base, "This company name is already in use")
    end
    if attr == :email && Client.find_by_email(value).present?
      record.errors.add(:base, "This email address is already in use")
    end
  end

  def save(user)
      begin
        Job.transaction do
          if first_time?
            save_first_time
          elsif is_applicant?
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

  def is_applicant?
    type == :is_applicant
  end

  def is_employer?
    type == :is_employer
  end

  def first_time?
    type == :first_time
  end

end
