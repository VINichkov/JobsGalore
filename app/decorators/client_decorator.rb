class ClientDecorator < ApplicationDecorator
  delegate_all
  decorates_association :job
  decorates_association :resume
  decorates_association :company

  def photo_url
    @photo_url ||= object.photo_uid.blank? || ENV["RAILS_ENV"]!='production'  ? h.image_url("avatar.jpg") : Dragonfly.app.remote_url_for(object.photo_uid)
  end
end