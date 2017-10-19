class Clients::RegistrationsController < Devise::RegistrationsController
 before_action :configure_sign_up_params, only: [:create]
 before_action :configure_account_update_params, only: [:update]
 before_action :configure_sign_up_employer_params, only: [:create_employer]

  # GET /resource/sign_up
   def new
     super
   end

  def sign_up_employer
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

   def create_employer
     param=sign_up__employer_params
     build_resource({firstname: param[:firstname],
                     lastname:param[:lastname],
                     location_id: param[:location_id],
                     phone: param[:phone],
                     email: param[:email],
                     password: param[:password],
                     gender:param[:gender]})
     resource.company.new(name: param[:company_name],
                          location_id:param[:location_id],
                          recrutmentagency:param[:recrutmentagency])
     resource.save
     yield resource if block_given?
     if resource.persisted?
       if resource.active_for_authentication?
         set_flash_message! :notice, :signed_up
         sign_up(resource_name, resource)
         respond_with resource, location: after_sign_up_path_for(resource)
       else
         set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
         expire_data_after_sign_in!
         respond_with resource, location: after_inactive_sign_up_path_for(resource)
       end
     else
       clean_up_passwords resource
       set_minimum_password_length
       puts resource
       respond_with resource, action: sign_up_employer_path
     end
   end
  # POST /resource
   def create
     super
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

   def configure_sign_up_employer_params
     devise_parameter_sanitizer.permit(:sign_up_employer, keys: [:firstname, :lastname, :company_name, :gender, :company_recrutment, :location_name, :location_id, :phone, :email, :password, :password_confirmation, :character])
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
     super(resource)
   end

   def sign_up__employer_params
     devise_parameter_sanitizer.sanitize(:sign_up_employer)
   end
end

