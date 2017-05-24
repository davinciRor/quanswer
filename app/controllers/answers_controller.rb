class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy, :update]
  before_action :find_question

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
  end

  def update
    @answer = @question.answers.find(params[:id])
    @answer.update(answer_params)
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
