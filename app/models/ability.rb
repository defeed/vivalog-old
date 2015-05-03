class Ability
  include CanCan::Ability

  def initialize(user)
    if user.administrator? || user.manager?
      can :manage, :all
    end

    if user.accountant?
      can [:read, :update], User
      can :manage, Project
    end

    if user.worker?
      can :find_by_start_date, Project
      can :create, Entry
      can [:read, :update], Entry, user_id: user.id
      can [:show_profile, :update], User, id: user.id
    end
  end
end
