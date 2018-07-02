class LinkedinClient <LinkedIn
  option :name, 'linke'

  def raw_info
    Rails.logger.debug('Зашли  в класс')
    @raw_info ||= access_token.get("/v1/people/~:(#{option_fields.join(',')})?format=json").parsed
  end
end

OmniAuth.config.add_camelization 'linke', 'LinkedinClient'