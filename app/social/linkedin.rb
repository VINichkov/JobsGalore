require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class LinkedIn < OmniAuth::Strategies::OAuth2
      option :scope, 'r_basicprofile r_emailaddress'
      option :fields, ['id', 'email-address', 'first-name', 'last-name', 'headline', 'location', 'industry', 'picture-url', 'public-profile-url', 'summary', 'positions']

      def raw_info
        Rails.logger.debug("_______________________________________________")
        Rails.logger.debug(access_token.to_json)
        Rails.logger.debug("/v1/people/~:(#{option_fields.join(',')})?format=json")
        Rails.logger.debug("_______________________________________________")
        @raw_info ||= access_token.get("/v1/people/~:(#{option_fields.join(',')})?format=json").parsed
      end

      def self.linkedin_to_h(auth)
        experience = auth&.extra&.raw_info&.positions[:values]&.last
        summary = auth&.extra&.raw_info&.summary.split("\n").compact.map{|t| "<p>#{t}</p>"}.join if auth.extra.raw_info.summary
        if experience
          location = "<p><strong> Location: </strong>"+ experience.location.name+"</p>" if experience.location.name
          date_start = "<p>#{Date.new(experience.startDate.year, experience.startDate.month).strftime('%b %Y')} - Present</p>" if experience.startDate
          experience_summary = experience.summary.split("\n").compact.map{|t| "<p>#{t}</p>"}.join if experience.summary
          experience_title = "<p><strong>#{experience.title}</strong></p>" if experience.title
          experience_company_name = "<p><strong>#{experience.company.name}</strong></p>" if experience.company&.name
          experience_first = "<h3>Experience</h3><hr>"+experience_title.to_s + experience_company_name.to_s + date_start.to_s+location.to_s+experience_summary.to_s+"<hr>"
          summary += experience_first.to_s
        end
        {title: auth.extra.raw_info.headline,
         industry_id: Industry.find_by_linkedin(auth.extra.raw_info.industry).id,
         location_id: (local ? local.id : Location.default.id),
         description: summary,
         sources: auth.info.urls.public_profile}
      end

      def self.get_profile(token)
        url = URI.parse('https://api.linkedin.com/v1/people/')
        connect = Net::HTTP::Get.new(url.to_s)
        connect.add_field(:authorization, "Bearer "+token.to_s)
        connect.add_field(:connection, 'Keep-Alive')
        connect.add_field('x-li-format', 'json')
        https =  Net::HTTP.new(url.host, url.port)
        https.use_ssl = true
        res = https.start {|http|
          http.request(a)
        }
        Rails.logger.debug "res #{res.body}"
      end
    end
  end
end

OmniAuth.config.add_camelization 'linkedin', 'LinkedIn'