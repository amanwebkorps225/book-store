
class Ability
  include CanCan::Ability

  def initialize(user)

    if user.present?

      if user.role == "admin"
        can :manage, :all  
      end

    end
  end
end