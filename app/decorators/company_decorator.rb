class CompanyDecorator < ApplicationDecorator
  delegate_all


  def logo_url
    @logo_url ? @logo_url  : @logo_url = object.logo_uid ? Dragonfly.app.remote_url_for(object.logo_uid) : h.image_url("company_profile.jpg")
  end

  def jobs_count
    @jobs_count ? @jobs_count: @jobs_count = object.job.count
  end

  def keywords
    @keywords ? @keywords : @keywords = "Australia, Job, Jobs, Galore, Jobsgalore,#{object.name}, #{markdown_to_keywords(object.description)}"
  end
end