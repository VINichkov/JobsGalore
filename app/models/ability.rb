class Ability
  include CanCan::Ability

  def initialize(user,param)
    puts "#{user}__________________________#{param}"
    user ||= Client.new
    if user.email == PropertsHelper::ADMIN
      puts "Cancan:: Admin"
      can :manage, :all
    elsif user.character == 'employer'
      puts "Cancan:: Employer"
      #############################################
      can [:new, :create, :profile, :settings, :edit, :update, :destroy, :edit_photo] , Client do |client|
        (client.id==user.id) or (client.company.client.find_by_id(user.id))
      end
      can [:settings_company, :edit_logo, :team, :new_member, :create_member, :destroy_member, :change_type, :edit, :update, :destroy, :edit_photo] , Company do |company|
        company.client.find_by_id(user.id)
      end
      can [:show, :company_jobs], Company
      can [:new, :create,:show], Job
      can [ :edit, :update, :destroy], Job do |job |
        job.company.client.find_by_id(user.id)
      end
      can [:search], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :log_in], Resume


      can [:settings_company, :edit_logo], :all
    elsif user.character == 'employee'
      puts "Cancan:: Employee"
      #############################################
      can [:edit, :update, :profile, :settings, :destroy, :edit_photo] , Client do |client|
        client==user
      end
      can [:show, :company_jobs], Company
      can [:new, :create,:show], Job
      can [ :edit, :update, :destroy], Job do |job |
        job.client==user
      end
      can [:search], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :show, :log_in], Resume


    elsif user.character == 'aplicant'
      puts "Cancan:: Aplicant"
      #############################################
      can [:edit, :update, :destroy, :profile, :settings, :edit_photo] , Client do |client|
        client==user
      end
      can [:show, :company_jobs], Company
      can [:new,:show], Job
      can [:search], Location
      can [:bill, :cancel_url, :create], Payment
      can [:new, :create, :show, :log_in], Resume
      can [ :edit, :update, :destroy], Resume do |resume|
        resume.client_id == user.id
      end
    else
      puts "Cancan:: Other"
      ##############################################
      can [:show], Job
      can [:show, :company_jobs], Company
      can [:search], Location
      can [:bill, :cancel_url, :create], Payment
      can [:show, :log_in], Resume
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
