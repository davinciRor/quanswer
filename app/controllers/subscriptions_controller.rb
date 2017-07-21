class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_question, only: [:create]

  skip_authorization_check

  respond_to :html

  def create
    @subscription = @question.subscriptions.create(user: current_user)
    redirect_to @question, notice: 'You subscribe on question!'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
