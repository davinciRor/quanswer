class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :toogle_notify]
  before_action :build_answer,  only: [:show]
  before_action :build_comment, only: [:show]

  after_action  :publish_question, only: [:create]

  authorize_resource

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

  def create
    respond_with(@question = current_user.questions.create(questions_params))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy, location: questions_path)
  end

  def toogle_notify
    @question.notify_author = !@question.notify_author
    @question.save
    redirect_to @question, notice: "You #{@question.notify_author? ? 'notify' : 'unnotify'} for question!"
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
