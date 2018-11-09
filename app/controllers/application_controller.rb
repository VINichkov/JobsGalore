
class ApplicationController < ActionController::Base
  extend ActiveSupport::Concern
  include Session
  rescue_from ActiveRecord::RecordNotFound, with:  :render_404
  rescue_from ActionController::RoutingError, with:  :render_404
  rescue_from CanCan::AccessDenied, with:  :render_404

  include ApplicationHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :clear_session

  private

  def clear_session
    if session[:workflow]
      unless session[:workflow] &&
          %w(resumes jobs companies clients locations registrations sessions omniauth_callbacks index).include?(controller_name) &&
          %w(linkedin new create search create_temporary create_job create_resume linkedin_resume_update file_to_html).include?(action_name)
        Rails.logger.debug "---!!! Зачистили сессию controller_name #{controller_name} action_name #{action_name} !!!---"
        session[:workflow] = nil
      end
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
    if current_client&.resp?
      if current_client.company.nil?
        client = add_new_workflow(class: :ClientWorkflow, client:current_client)
        client.save!(session[:workflow])
        redirect_to workflow_link(client), notice: 'Please, enter information about your company.'
        nil
      else
        current_client.company
      end
    end
  end

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end


  Draper.configure do |config|
    config.default_controller = ApplicationController
  end


  def current_client
    super&.decorate
  end

end
