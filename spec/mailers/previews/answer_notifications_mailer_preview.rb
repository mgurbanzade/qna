class AnswerNotificationsMailer < ActionMailer::Preview
  def notify
    AnswerNotificationsMailer.notify(User.first, Answer.first)
  end
end
