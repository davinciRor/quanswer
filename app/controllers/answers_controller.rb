class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :find_question, only: [:create, :update, :make_best, :destroy]
  before_action :find_answer, only: [:update, :make_best, :destroy]

  after_action :publish_answer, only: [:create]

  include Voted

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def make_best
    @answer.make_best! if current_user.author_of?(@question)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def publish_answer
    ActionCable.server.broadcast(
        "answers_for_question_#{params[:question_id]}",
        answer: @answer.as_json(include: :attachments).merge({rating: @answer.rating}).to_json
    )
  end

  def find_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :_destroy])
  end
end
