class AnswerMailer < ApplicationMailer
  default from: 'form@example.com'

  def create(answer)
    @answer = answer
    mail to: answer.question.user.email
  end

  def subscribe(answer, user)
    @answer = answer
    @user = user
    mail to: @user.email
  end
end