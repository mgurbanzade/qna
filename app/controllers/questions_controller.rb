class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :new_question, only: :index
  before_action :new_answer, only: :show
  after_action :publish_question, only: :create

  respond_to :html, :js

  def index
    respond_with(@questions = Question.all.by_last)
  end

  def show
    respond_with(@answer = @question.answers.new)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with @question
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def new_question
    @question = Question.new
  end

  def new_answer
    @answer = Answer.new
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
