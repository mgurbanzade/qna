class Ability
  include CanCan::Ability

  def initialize(user)
    user ? user_abilities(user) : guest_abilities
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities(user)
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

    can_vote(:like, user)
    can_vote(:dislike, user)
  end

  def can_vote(action, user)
    can action, [Question, Answer] do |resource|
      !user.author_of?(resource) && !resource.voted?(user)
    end
  end
end
