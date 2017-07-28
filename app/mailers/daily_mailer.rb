class DailyMailer < ApplicationMailer
  default from: 'form@example.com'

  def digest(user)
    @questions = Question.today

    mail to: user.email
  end
end
