class ClientDecorator < ApplicationDecorator
  delegate_all

  def photo_url
    @photo_url? @photo_url : @photo_url = object.photo_uid ? Dragonfly.app.remote_url_for(object.photo_uid) : h.image_url("avatar.jpg")
  end
end