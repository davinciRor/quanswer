class DailyMailer < ApplicationMailer
  default from: 'form@example.com'

  def digest(user)
    @greeting = 'Hi'

    mail to: user.email
  end
end
