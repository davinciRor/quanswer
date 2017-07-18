class AnswerMailer < ApplicationMailer
  default from: 'form@example.com'

  def create(answer)
    @answer = answer
    mail to: answer.question.user.email
  end
end