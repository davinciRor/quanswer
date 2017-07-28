class AnswerCreateJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerMailer.create(answer).deliver_later
  end
end
