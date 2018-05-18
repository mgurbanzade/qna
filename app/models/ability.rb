class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_abilities(user) : guest_abilities
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment, User]
  end

  def user_abilities(user)
    guest_abilities
    can :create, [Question, Answer, Comment, Rate]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Attachment, Rate], user_id: user.id
  end
end
