class Clients::RegistrationsController < Devise::RegistrationsController
 before_action :configure_sign_up_params, only: [:create]
 before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
   def new
     build_resource
     if session[:workflow]
      session[:workflow] = ApplicationWorkflow.desirialize(session[:workflow])
      Rails.logger.debug "Clients::RegistrationsController::new @client_wf = #{session[:workflow].to_json}"
      session[:workflow].client= resource
     else
       session[:workflow] = ClientWorkflow.new(resource)
     end
     @client_wf=session[:workflow]
     Rails.logger.debug "Clients::RegistrationsController::new @client_wf = #{@client_wf.to_json}"
   end

  # POST /resource
   def create
     session[:workflow] = ApplicationWorkflow.desirialize(session[:workflow])
     session[:workflow].client.update(sign_up_params)
     @client_wf = session[:workflow]
     @client_wf.client.save
     if @client_wf.client.persisted?
       if @client_wf.client.active_for_authentication?
         set_flash_message! :notice, :signed_up
         sign_up(resource_name, @client_wf.client)
         respond_with @client_wf.client, location: @client_wf.url ? @client_wf.url : after_sign_up_path_for(@client_wf.client)
       else
         set_flash_message! :notice, :"signed_up_but_#{@client_wf.client.inactive_message}"
         expire_data_after_sign_in!
         respond_with @client_wf.client, location: @client_wf.url ? @client_wf.url : after_inactive_sign_up_path_for(@client_wf.client)
       end
     else
       clean_up_passwords @client_wf.client
       set_minimum_password_length
       Rails.logger.debug "Не сохранили #{@client_wf.to_json}"
       respond_with @client_wf.client
     end
   end

  # GET /resource/edit
   def edit
     super
   end

  # PUT /resource
   def update
     super
   end

  # DELETE /resource
   def destroy
     resource.company.each do |company|
       company.destroy
     end
     super
   end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
   def cancel
     super
   end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
   end


  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
     devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
   end

  # The path used after sign up.
   def after_sign_up_path_for(resource)
     super(resource)
   end

  # The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
     Rails.logger.debug "!!!!!!!!! after_inactive_sign_up_path_for____________Зашли #{resource}"
     super(resource)
   end

end

