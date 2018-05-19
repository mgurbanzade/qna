class Ability
  include CanCan::Ability
  attr_reader :user

  def initialize(user)
    @user = user
    @user ? user_abilities : guest_abilities
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id

    can :destroy, Attachment do |a|
      user.author_of?(a.attachable)
    end

    can :best_answer, Answer do |answer|
      user.author_of?(answer.question) && !user.author_of?(answer)
    end

    can_vote(:like)
    can_vote(:dislike)
    can :me, User, id: user.id
  end

  def can_vote(action)
    can action, [Question, Answer] do |resource|
      !user.author_of?(resource)
    end
  end
end
