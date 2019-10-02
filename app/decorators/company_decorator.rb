class CompanyDecorator < ApplicationDecorator
  delegate_all
  decorates_finders
  decorates_association :job
  decorates_association :client

  def logo_url
    if @logo_url.blank?
      if object.logo_uid.blank? || ENV["RAILS_ENV"] != 'production'
        @logo_url = h.image_url("company_profile.jpg")
      else
        @logo_url = Dragonfly.app.remote_url_for(object.logo_uid)
      end
    end
    @logo_url
  end

  def jobs_count
    @jobs_count ||= object.job.count
  end

  def keywords
    @keywords ||= "Jobs Galore, Australia, Job, Jobs, Galore, Jobsgalore, #{object.name}, #{object.full_keywords(14).join(", ")}"
  end
end