<<<<<<< HEAD
# Configure dkim globally (see above)
Dkim::domain      = 'jobsgalore.eu  '
Dkim::selector    = 'email'
Dkim::private_key = open('private.pem').read

# This will sign all ActionMailer deliveries
=======
# Configure dkim globally (see above)
Dkim::domain      = 'jobsgalore.eu  '
Dkim::selector    = 'email'
Dkim::private_key = open('private.pem').read

# This will sign all ActionMailer deliveries
>>>>>>> 0066c0178741d550022581a86e9d3c71709682d0
ActionMailer::Base.register_interceptor(Dkim::Interceptor)