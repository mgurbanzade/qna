class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.by_latest

    mail to: user.email
  end
end
