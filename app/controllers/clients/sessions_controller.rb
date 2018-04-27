class Clients::SessionsController < Devise::SessionsController
before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
   def new
     super do
       if session[:workflow]
         session[:workflow] = ApplicationWorkflow.desirialize(session[:workflow])
         session[:workflow].client= resource
       else
         session[:workflow] = ClientWorkflow.new(resource)
       end
     end
   end

  # POST /resource/sign_in
   def create
     self.resource = warden.authenticate!(auth_options)
     session[:workflow] = ApplicationWorkflow.desirialize(session[:workflow]) if session[:workflow]
     if resource.validate_workflow(session[:workflow]&.class)
       workflow = session[:workflow]
       Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
       session.clear
       session[:workflow] = workflow
       set_flash_message! :alert, :"sign_in_#{resource.errors[:character][0]}"
       redirect_to new_client_session_path
     else
       session[:workflow].client = resource if session[:workflow]
       @url = session[:workflow].url if session[:workflow]
       set_flash_message!(:notice, :signed_in)
       sign_in(resource_name, resource)
       respond_with resource, location: after_sign_in_path_for(resource)
     end
   end

  # DELETE /resource/sign_out
   def destroy
     super
   end

   protected
   def after_sign_in_path_for(arg)
     @url ? @url : super(arg)
   end
  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
   end

   def auth_options
     { scope: resource_name, recall: "#{controller_path}#new" }
   end
end
