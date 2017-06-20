module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:like, :dislike, :unvote]
    before_action :can_vote?, only: [:like, :dislike, :unvote]
  end

  def like
    @vote = @votable.votes.build(mark: 1, user: current_user)

    respond_to do |format|
      if @vote.save
        format.json { render json: @vote }
      else
        format.json { render json: @vote.errors.messages.values, status: :unprocessable_entity }
      end
    end
  end

  def dislike
    @vote = @votable.votes.build(mark: -1, user: current_user)

    respond_to do |format|
      if @vote.save
        format.json { render json: @vote }
      else
        format.json { render json: @vote.errors.messages.values, status: :unprocessable_entity }
      end
    end
  end

  def unvote
    @vote = Vote.where(user: current_user, votable: @votable).first
    @vote.destroy
    respond_to do |format|
      format.json { render json: { mark: @vote.mark * -1 } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def can_vote?
    if current_user.author_of?(@votable)
      render json: { error: "Author can't vote for own question" }, status: :forbidden
    end
  end
end
