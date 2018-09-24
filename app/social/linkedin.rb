require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth2


      option :scope, 'r_basicprofile r_emailaddress r_fullprofile'

      def access_token
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
            :mode => :query,
            :param_name => 'oauth2_access_token',
            :expires_in => oauth2_access_token.expires_in,
            :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        puts "get #{"/v1/people/~:(#{option_fields.join(',')})?format=json"}"
        puts "options #{access_token.options.to_json}"
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        @raw_info ||= access_token.get("/v1/people/~:(#{option_fields.join(',')})?format=json").parsed
      end

      credentials do
        hash = {access_token: access_token.token}
        hash[:client] = client
        hash[:param_name] = 'oauth2_access_token'
        hash[:expires_in ] = 'oauth2_access_token.expires_in'
        hash[:refresh_token] = access_token.refresh_token if access_token.expires? && access_token.refresh_token
        hash[:expires_at] = access_token.expires_at if access_token.expires?
        hash[:expires] = access_token.expires?
        hash
      end

      private

      def option_fields
        fields = options.fields
        fields.map! { |f| f == "picture-url" ? "picture-url;secure=true" : f } if !!options[:secure_image_url]
        fields
      end

      def user_name
        name = "#{raw_info['firstName']} #{raw_info['lastName']}".strip
        name.empty? ? nil : name
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'