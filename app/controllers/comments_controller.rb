class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.json { render json: @comment }
      else
        format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def publish_comment
    if @commentable.is_a? Question
      ActionCable.server.broadcast(
          "comments_for_question_#{params[:question_id]}",
          comment: @comment.attributes.merge({ user_email: @comment.user.email }).to_json
      )
    elsif @commentable.is_a? Answer
      ActionCable.server.broadcast(
          "comments_for_answer_#{params[:answer_id]}",
          comment: @comment.attributes.merge({ user_email: @comment.user.email }).to_json
      )
    end
  end

  private

  def set_commentable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @commentable= klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
