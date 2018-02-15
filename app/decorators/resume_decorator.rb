class ResumeDecorator < ApplicationDecorator
  delegate_all

  def description_meta
    @description_meta ? @description_meta : @description_meta = markdown_to_text(object.description, 300)
  end

  def keywords
    @keywords ? @keywords : @keywords = "Australia, Resumes, Resume, Galore, Jobsgalore,#{object.title}, Talent in #{object.location.name}, Talent, #{markdown_to_keywords(object.title)}"
  end

  def client_photo
    @client_photo? @client_photo : @client_photo = object.client.decorate.photo_url
  end
end