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

  #POST /resource/sign_in
   def create
     super do
       session[:workflow] = ApplicationWorkflow.desirialize(session[:workflow]) if session[:workflow]
       session[:workflow].client = resource if session[:workflow]
       @url = session[:workflow].url if session[:workflow]
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
