class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: [:show]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions
  end

  def show
    respond_with(@question)
  end

  def create
    respond_with(@question = current_resource_owner.questions.create(question_params))
  end

  private

  def question_params
    params.require(:question).permit(:body, :title)
  end

  def set_question
    @question = Question.find(params[:id])
  end
end