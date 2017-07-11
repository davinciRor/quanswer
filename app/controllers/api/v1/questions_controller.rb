class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with(@question)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
end