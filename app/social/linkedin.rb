require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth2
      option :scope, 'r_basicprofile r_emailaddress'
      option :fields, ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'picture-url', 'public-profile-url', 'summary', 'positions']
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'