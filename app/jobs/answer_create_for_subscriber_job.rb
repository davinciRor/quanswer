class AnswerCreateForSubscriberJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      AnswerMailer.subscribe(answer, user).deliver_later
    end
  end
end