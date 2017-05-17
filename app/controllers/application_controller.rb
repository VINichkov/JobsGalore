class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:location_id, :firstname, :lastname, :phone, :resp, :photo, :photo, :gender])
  end

  # In ApplicationController
  def current_ability
  @current_ability ||=Ability.new(current_client)
  end

  rescue_from CanCan::AccessDenied do |exception|
    puts "____________________"
    puts exception
    puts "____________________"
    respond_to do |format|
      format.json { head :forbidden , content_type: ' text/html ' }
      format.html { redirect_to sign_in, notice: exception.message }
      format.js { head :forbidden , content_type: ' text/html ' }
      end
  end

  #app/controllers/application_controller.rb
  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/not_found_error', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end
end
