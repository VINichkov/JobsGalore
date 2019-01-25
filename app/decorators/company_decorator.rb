class CompanyDecorator < ApplicationDecorator
  delegate_all
  decorates_findersls
  decorates_association :job
  decorates_association :client

  def logo_url
    @logo_url ||= object.logo_uid ? Dragonfly.app.remote_url_for(object.logo_uid) : h.image_url("company_profile.jpg")
  end

  def jobs_count
    @jobs_count ||= object.job.count
  end

  def keywords
    @keywords ||= "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{object.name}, #{object.full_keywords(14).join(", ")}"
  end
end