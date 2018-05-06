module Rateable
  extend ActiveSupport::Concern

  included do
    has_many :rates, as: :rateable, dependent: :destroy
  end

  def toggle_like(user)
    return unvote(user, 1) if voted?(user)
    rates.create!(vote: 1, user: user)
  end

  def toggle_dislike(user)
    return unvote(user, -1) if voted?(user)
    rates.create!(vote: -1, user: user)
  end

  def unvote(user, vote)
    rates.where(user: user, vote: vote).delete_all
  end

  def rating
    rates.sum(:vote)
  end

  def voted?(user)
    rates.exists?(user: user)
  end

  def liked?(user)
    rates.exists?(user: user, vote: 1)
  end

  def disliked?(user)
    rates.exists?(user: user, vote: -1)
  end

  def vote_type(user)
    return 'liked' if liked?(user)
    return 'disliked' if disliked?(user)
    return 'not voted'
  end
end
