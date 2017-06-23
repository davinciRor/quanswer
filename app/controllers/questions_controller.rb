class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer,  only: [:show]
  before_action :build_comment, only: [:show]

  after_action  :publish_question, only: [:create]

  include Voted

  respond_to :html, except: [:update]
  respond_to :js, only: [:update]

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) if current_user.author_of?(@question)
  end

  private

  def build_answer
    @answer = @question.answers.build
  end

  def build_comment
    @comment = @question.comments.build
  end

  def publish_question
    return if @question.errors.any?
    _question = @question.attributes.merge({rating: @question.rating})
    ActionCable.server.broadcast(
        'questions',
        { question: _question.to_json }
    )
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
