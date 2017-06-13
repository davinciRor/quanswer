class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "answers_#{data[:id]}"
  end
end