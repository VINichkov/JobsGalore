require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth2
      option :scope, 'r_basicprofile r_emailaddress rw_company_admin w_share'
      option :fields, ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'picture-url', 'public-profile-url', 'summary', 'positions']

      def raw_info
        Rails.logger.debug("_______________________________________________")
        Rails.logger.debug(access_token.to_json)
        Rails.logger.debug("/v1/people/~:(#{option_fields.join(',')})?format=json")
        Rails.logger.debug("_______________________________________________")
        @raw_info ||= access_token.get("/v1/people/~:(#{option_fields.join(',')})?format=json").parsed
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'