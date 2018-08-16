class Clients::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
   def linkedin
     Rails.logger.debug "---Clients::OmniauthCallbacksController linkedin"
       # You need to implement the method below in your model (e.g. app/models/user.rb)
     @client = Client.from_omniauth(request.env["omniauth.auth"])
     puts "request.env #{request.env["omniauth.auth"].to_json}"
     @client_wf = wf(client:@client)
     if @client.persisted?
       @client_wf.save!(session[:workflow])
       sign_in_and_redirect @client, event: :authentication #this will throw if @user is not activated
       set_flash_message(:notice, :success, kind: "LinkedIn") if is_navigational_format?
     else
       session["devise.linkedin_data"] = request.env["omniauth.auth"]
       redirect_to new_client_registration_url
     end
   end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
   def passthru
     super
   end

  # GET|POST /users/auth/twitter/callback
   def failure
     super
   end

  # protected

  # The path used when OmniAuth fails
   def after_omniauth_failure_path_for(scope)
     super(scope)
   end

   def after_sign_in_path_for(resource)
     Rails.logger.debug "---Clients::OmniauthCallbacksController after_sign_in_path_for"
     patch = workflow_link(@client_wf)
     patch ? patch : super(resource)
   end
end
