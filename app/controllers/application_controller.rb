class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, :with => {render_404}
  rescue_from ActionController::RoutingError, :with => {render_404}
  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :extras_check
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:location_id, :firstname, :lastname, :phone, :resp, :photo, :photo, :gender, :birth])
  end

  # In ApplicationController
  def current_ability
  @current_ability ||=Ability.new(current_client, params)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden , content_type: ' text/html ' }
      format.html { redirect_to "/404", notice: exception.message }
      format.js { head :forbidden , content_type: ' text/html ' }
      end
  end



  def render_404
    respond_to do |format|
      format.json { head :forbidden , content_type: ' text/html ' }
      format.html { redirect_to "/404", notice: exception.message }
      format.js { head :forbidden , content_type: ' text/html ' }
    end
  end


  def extras_check
    if $date.mem < Date.today
      Thread.new do
        begin
          extras_off
        rescue
          puts "____________________Error: #{$!}"
        end
      end
      $date.mem = Date.today
    end
  end

end
