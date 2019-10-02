class ClientDecorator < ApplicationDecorator
  delegate_all
  decorates_association :job
  decorates_association :resume
  decorates_association :company

  def photo_url
    if @photo_url.blank?
      if object.photo.blank? || ENV["RAILS_ENV"] != 'production'
        @photo_url = h.image_url("avatar.jpg")
      else
        @photo_url = Dragonfly.app.remote_url_for(object.photo_uid)
      end
    end
    @photo_url
  end
end