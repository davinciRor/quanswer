class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers_for_question_#{params[:question_id]}"
  end
end