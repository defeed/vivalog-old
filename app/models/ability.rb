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
      can :create, Entry
      can [:read, :update], Entry, user_id: user.id
    end
  end
end
