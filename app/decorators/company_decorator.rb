class CompanyDecorator < ApplicationDecorator
  delegate_all

  attr_reader :logo_url, :description_html, :jobs_count, :industries_count, :keywords, :description_meta, :location_full

  def initialize(object, options = {})
    super
    @logo_url = object.logo_uid ? Dragonfly.app.remote_url_for(object.logo_uid) : h.image_url("company_profile.jpg")
    @description_html = object.description ? RDiscount.new(object.description).to_html.gsub('<img', "<img class=\"img-thumbnail center-block\" ") : ""
    @jobs_count = object.job.count
    @industries_count = object.industry.count
    @keywords = "Australia, Job, Jobs, Galore, Jobsgalore,#{object.name}, #{markdown_to_keywords(object.description)}"
    @description_meta = markdown_to_text(object.description, 300)
    @location_full = "#{object.location.suburb}, #{object.location.state}"
  end




end