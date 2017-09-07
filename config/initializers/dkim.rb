# Configure dkim globally (see above)
Dkim::domain      = 'jobsgalore.eu  '
Dkim::selector    = 'email'
Dkim::private_key = open('private.pem').read

# This will sign all ActionMailer deliveries
ActionMailer::Base.register_intergitceptor(Dkim::Interceptor)