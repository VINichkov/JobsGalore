class CreatorsJob::CreateOnlyJob < CreateJobParent

  def save(user)
    self.validate!
    if user.company.blank?
      errors.add(:base, "The company can't be blank.")
      raise ActiveRecord::RecordInvalid
    end
    Job.transaction do
      Job.create!(
          title: title,
          description: description,
          location_id: location_id,
          company: user.company,
          client: user
      )
    end
  end


end