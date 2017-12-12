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
    @current_ability ||=Ability.new(current_client, params)
  end

  def admin!
    authenticate_client!
    if current_client.email == PropertsHelper::ADMIN
      true
    else
      render_404
    end
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end

  Draper.configure do |config|
    config.default_controller = ApplicationController
  end

end
