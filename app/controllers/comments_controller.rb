class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  after_action :publish_comment, only: [:create]

  respond_to :json

  def create
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    respond_with @comment do |format|
      format.json { render json: comment_errors, status: :unprocessable_entity } if @comment.invalid?
    end
  end

  def publish_comment
    ActionCable.server.broadcast(
        'comments',
        comment: @comment.attributes.merge({ user_email: @comment.user.email }).to_json
    )
  end

  private

  def comment_errors
    {
        commentable_id: @comment.commentable_id,
        commentable_type: @comment.commentable_type,
        errors: @comment.errors.full_messages
    }
  end

  def set_commentable
    klass = [Question, Answer].detect{|c| params["#{c.name.underscore}_id"]}
    @commentable= klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
