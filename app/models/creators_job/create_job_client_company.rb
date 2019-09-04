class CreatorsJob::CreateJobClientCompany < CreatorsJob::CreateJobParent

  CJCC_ATTR_NAMES={
      email: "Email",
      location_id: "City",
      title: "Title",
      password: "Password",
      company_name: "Company name"
  }

  attribute :email
  attribute :password
  attribute :company_name

  validates_each  :email, :password, :company_name do |record, attr, value|
    record.errors.add(:base, "The field '#{CJCC_ATTR_NAMES[attr]}' can't be blank") if value.blank?
  end

  validates_each :email do |record, attr, value|
    record.errors.add(:base, "This email address is already in use") if Client.find_by_email(value).present?
  end

  validates_each :company_name do |record, attr, value|
    record.errors.add(:base, "This company name is already in use") if Company.find_by_name(value).present?
  end

  def save
    self.validate!
    Job.transaction do
      company = create_company
      create_client(company)
      Job.create!(
          title: title,
          description: description,
          location_id: location_id,
          company: company,
          client: client
      )
    end
  end


  private



  def create_client(company)
    Client.create!(
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

  def create_company
    Company.create!(name: company_name, location_id: location_id)
  end


end
