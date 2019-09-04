class CreatorsJob::CreateJobCompany < CreatorsJob::CreateJobParent
  CJC_ATTR_NAMES={
      company_name: "Company name"
  }

  attribute :company_name

  validates_each  :company_name do |record, attr, value|
    record.errors.add(:base, "The field '#{CJC_ATTR_NAMES[attr]}' can't be blank") if value.blank?
  end

  validates_each :company_name do |record, attr, value|
    record.errors.add(:base, "This company name is already in use") if Company.find_by_name(value).present?
  end

  def save(user)
    self.validate!
    Job.transaction do
      company = create_company
      update_client(user, company)
      Job.create!(
          title: title,
          description: description,
          location_id: location_id,
          company: company,
          client: user
      )
    end
  end


  private



  def update_client(user, company)
    user.update(character: TypeOfClient::EMPLOYER, company: company)
  end

  def create_company
    Company.create!(name: company_name, location_id: location_id)
  end


end