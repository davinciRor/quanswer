class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :find_question

  def show
    @answer = @question.answers.find(params[:id])
  end

  def new
    @answer = @question.answers.build(user: current_user)
  end

  def create
    @answer = @question.answers.build(answer_params.merge({ user: current_user }))
    if @answer.save
      redirect_to question_path(@question)
    else
      flash[:error] = 'You fill invalid data.'
      redirect_to question_path(@question)
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy
    redirect_to question_path(@question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
