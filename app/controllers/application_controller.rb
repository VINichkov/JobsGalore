class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with:  :render_404
  rescue_from ActionController::RoutingError, with:  :render_404
  rescue_from CanCan::AccessDenied, with:  :render_404

  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:location_id, :firstname, :lastname, :phone, :character, :photo, :photo, :gender, :birth])
  end

  # In ApplicationController
  def current_ability
    @current_ability ||=Ability.new(current_client)
  end

  def admin!
    authenticate_client!
    if current_client.admin?
      true
    else
      render_404
    end
  end

  def current_company
    @company = current_client.company
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end


  Draper.configure do |config|
    config.default_controller = ApplicationController
  end

  protected

  def current_client
    super&.decorate
  end



end
