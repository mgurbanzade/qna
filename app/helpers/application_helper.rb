module ApplicationHelper
  def time(time)
    "#{time_ago_in_words(time.created_at)} ago"
  end
end
