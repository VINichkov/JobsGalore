class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Client.new
    Rails.logger.debug "#{user.id} #{user.firstname} #{user.lastname} #{user.email}"
    if user.admin?
      Rails.logger.debug "Cancan:: Admin"
      can :manage, :all
    elsif user.employer?
      Rails.logger.debug "Cancan:: Employer"
      #############################################
      can [ :profile, :settings, :team, :edit, :update, :destroy, :edit_photo, :change_type, :destroy_member, :update_photo] , Client do |client|
        (client==user) || (client.company.client.find_by_id(user.id))
      end
      can [:new_member, :create_member] , Client
      can [:settings_company, :edit_logo, :update_logo, :edit, :update, :destroy] , Company do |company|
        company.client.include?(user)
      end
      can [:new] , Company do |company|
        user.company.nil?
      end
      can [:show, :create, :company_jobs], Company
      can [:new, :create_job, :show, :create_temporary, :create_job], Job
      can [:edit, :update, :destroy], Job do |job |
        job.company.client.include?(user)
      end
      can [:search, :in_location], Location
      can [:bill, :cancel_url, :create], Payment
      can [:show], Resume


      can [:settings_company, :edit_logo], :all
    elsif user.character == 'employee'
      Rails.logger.debug "Cancan:: Employee"
      #############################################
      can [:edit, :update, :profile, :settings, :destroy, :edit_photo, :update_photo] , Client do |client|
        client==user
      end
      can [:show, :company_jobs], Company
      can [:new, :create_job, :show, :create_temporary, :create_job], Job
      can [ :edit, :update, :destroy], Job do |job|
        job.client==user
      end
      can [:search, :in_locationgit ], Location
      can [:bill, :cancel_url, :create], Payment
      can [:show ], Resume
      can :manage, Industryjob


    elsif user.character == 'applicant'
      Rails.logger.debug "Cancan:: Applicant"
      #############################################
      can [:edit, :update, :destroy, :profile, :settings, :edit_photo, :update_photo] , Client do |client|
        client==user
      end
      can [:show, :company_jobs], Company
      can [:show], Job
      can [:search, :in_location], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :create_temporary,  :create_resume], Resume
      can [ :edit, :update, :destroy], Resume do |resume|
        resume.client_id == user.id
      end
    else
      Rails.logger.debug "Cancan:: Other"
      ##############################################
      can [:new, :show, :create_temporary,  :create_job], Job
      can [:new, :create, :show, :company_jobs], Company
      can [:search, :in_location], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :create_temporary,  :create_resume], Resume
      #can [:index], Industry
    end

    def can?(action, subject, *extra_args)
      Rails.logger.debug "Cancan:: action #{action}  | subject #{subject}"
      if subject.class < Draper::Decorator
        subject = subject.model
      end
      super(action, subject, extra_args)
    end

  end
end
