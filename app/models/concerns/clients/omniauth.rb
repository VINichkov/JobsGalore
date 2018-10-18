module Omniauth
  extend ActiveSupport::Concern

  def self.from_omniauth(auth)
    Rails.logger.debug "Client::from_omniauth #{auth.to_json}"
    local = Location.search((auth.info.location.name.delete("!.,:*&()'`\"’").split(" ").map {|t| t=t+":*"}).join("|")).first
    client = where(provider: auth.provider, uid: auth.uid).or(where(email: auth.info.email)).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.firstname = auth.info.first_name
      user.lastname = auth.info.last_name
      user.token = auth.credentials.token
      user.sources = auth.info.urls.public_profile
      user.location = (local ? local : Location.default)
      user.photo_url = auth.info.image # assuming the user model has an image
      user.character=TypeOfClient::APPLICANT
      user.provider = auth.provider
      user.uid = auth.uid
      user.skip_confirmation!
    end
    client.update(token: auth.credentials.token, sources: auth.info.urls.public_profile)
    [client, Resume.new(LinkedInClient.new.linkedin_to_h(auth))]
  end

  def self.new_with_session(params, session)
    Rails.logger.debug "new_with_session зашли"
    super.tap do |user|
      Rails.logger.debug "Создали новую сессию"
      if data = session["devise.linkedin_data"] && session["devise.linkedin_data"]["extra"]["raw_info"]
        Rails.logger.debug "Обновим все"
        user.provider ||=auth.provider
        user.uid ||=auth.uid
        user.token = auth.credentials.token
        user.sources ||= auth.info.urls.public_profile
        user.photo_url ||= auth.info.image
      end
    end
  end
end