module RatesHelper
  def like_title(resource)
    resource.liked?(current_user) ? 'Unvote' : 'Like'
  end

  def dislike_title(resource)
    resource.disliked?(current_user) ? 'Unvote' : 'Dislike'
  end
end
