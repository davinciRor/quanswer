class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :edit, :update, :destroy, :like, :dislike]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(questions_params)
    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(questions_params) if current_user.author_of?(@question)
  end

  def destroy
    @question.destroy if current_user.author_of?(@question)
    redirect_to questions_path
  end

  def like
    @vote = @question.votes.create(mark: 1, user: current_user)
    respond_to do |format|
      format.json { render json: @vote }
    end
  end

  def dislike
    @vote = @question.votes.create(mark: -1, user: current_user)
    respond_to do |format|
      format.json { render json: @vote }
    end
  end

  private

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
