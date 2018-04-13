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
      can [ :profile, :settings, :team, :edit, :update, :destroy, :edit_photo, :change_type, :destroy_member] , Client do |client|
        (client==user) || (client.company.client.find_by_id(user.id))
      end
      can [:new_member, :create_member] , Client
      can [:settings_company, :edit_logo,  :edit, :update, :destroy, :edit_photo] , Company do |company|
        company.client.find_by_id(user.id)
      end
      can [:new] , Company do |company|
        user.company.nil?
      end
      can [:show, :create, :company_jobs], Company
      can [:new, :create_job, :show], Job
      can [:edit, :update, :destroy], Job do |job |
        job.company.client.include?(user)
      end
      can [:search, :in_location], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :log_in], Resume


      can [:settings_company, :edit_logo], :all
    elsif user.character == 'employee'
      Rails.logger.debug "Cancan:: Employee"
      #############################################
      can [:edit, :update, :profile, :settings, :destroy, :edit_photo] , Client do |client|
        client==user
      end
      can [:show, :company_jobs], Company
      can [:new, :create_job, :show, :create_temporary], Job
      can [ :edit, :update, :destroy], Job do |job|
        job.client==user
      end
      can [:search, :in_locationgit ], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :log_in], Resume
      can :manage, Industryjob


    elsif user.character == 'applicant'
      Rails.logger.debug "Cancan:: Applicant"
      #############################################
      can [:edit, :update, :destroy, :profile, :settings, :edit_photo] , Client do |client|
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
      Rails.logger.debug "!Cancan:: action #{action}  | subject #{subject}  | extra_args #{extra_args}"
      if subject.class < Draper::Decorator
        subject = subject.model
      end
      super(action, subject, extra_args)
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
