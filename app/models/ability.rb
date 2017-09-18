class Ability
  include CanCan::Ability

  def initialize(user,param )
    user ||= Client.new
    if user.resp
      can [:new], Resume
      can [:new, :create], Job
      can [ :edit, :update, :destroy], Job, Job do |job |
        not(job.company.client.find_by_id(user.id).nil?)
      end
      can [:edit, :update, :destroy] , Company, Company do |company|
        not(company.client.find_by_id(user.id).nil?)
      end
      can [:settings_company, :edit_logo], :all
    else
      can [:new], Job
      can [:new, :create], Resume
      can [ :edit, :update, :destroy], Resume, Resume do |resume|
        resume.client_id == user.id
      end
    end
    can [:edit, :update, :destroy] , Client, Client do |client|
      client.id==user.id
    end

    if user.email == PropertsHelper::ADMIN
      can :manage, Resume
      can :manage, Job
      can :manage, Industrycompany
      can :manage, Industryjob
      can :manage, Industryresume
      can :manage, Responsible
      can :manage, Size
      can :manage, Industry
      can :manage, Propert
      can :manage, Client
      can :read, Payment
    else

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
