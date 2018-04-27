class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with:  :render_404
  rescue_from ActionController::RoutingError, with:  :render_404
  rescue_from CanCan::AccessDenied, with:  :render_404

  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clear_session

  private
  def clear_session
    if !['resumes','jobs','companies','clients'].include?(controller_name) and !['new','create'].include?(action_name)
      session[:workflow] = nil if session[:workflow]
    end
  end

  protected


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:location_id, :firstname, :lastname, :phone, :character, :photo, :photo, :gender, :birth])
  end

  # In ApplicationController
  def current_ability
    @current_ability ||=Ability.new(current_client)
  end


  def current_company
    if current_client.resp?
        if current_client.company.nil?
          session[:workflow] = ClientWorkflow.new(current_client)
          redirect_to session[:workflow].url, notice: 'Please, enter information about your company.'
        else
          #format.html.none
          Rails.logger.debug "ApplicationController::current_client.company = #{current_client.company.to_json}"
          current_client.company
        end
    end
  end

  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end


  Draper.configure do |config|
    config.default_controller = ApplicationController
  end


  def current_client
    super&.decorate
  end

end
