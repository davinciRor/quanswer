class CommentsChannel < ApplicationCable::Channel
  def follow_for_question
    stream_from "comments_for_question_#{params[:question_id]}"
  end

  def follow_for_answer
    stream_from "comments_for_answer_#{params[:answer_id]}"
  end
end