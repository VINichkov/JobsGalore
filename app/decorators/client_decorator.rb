class ClientDecorator < ApplicationDecorator
  delegate_all
  decorates_association :job
  decorates_association :resume
  decorates_association :company

  def photo_url
    @photo_url? @photo_url : @photo_url = object.photo_uid ? Dragonfly.app.remote_url_for(object.photo_uid) : h.image_url("avatar.jpg")
  end
end