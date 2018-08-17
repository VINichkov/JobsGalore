require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth2


      def access_token
        puts "oauth2_access_token.token = #{oauth2_access_token.token.to_s}"
        puts "oauth2_access_token.class = #{oauth2_access_token.class}"
        puts "oauth2_access_token.class = #{oauth2_access_token.to_json}"
        ::OAuth2::AccessToken.new(client, oauth2_access_token.token, {
            :mode => :query,
            :param_name => 'oauth2_access_token',
            :expires_in => oauth2_access_token.expires_in,
            :expires_at => oauth2_access_token.expires_at
        })
      end

      def raw_info
        @raw_info ||= access_token.get("/v1/people/~:(#{option_fields.join(',')})?format=json").parsed
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