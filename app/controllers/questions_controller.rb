class QuestionsController < ApplicationController
  include Rated

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy, :subscribe_author]
  before_action :find_subscription, only: [:show, :update]
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @question = Question.new
    @question.attachments.new
    @questions = Question.all.by_last
  end

  def show
    @answer = Answer.new
    @answer = @question.answers.new
    @answer.attachments.new
  end

  def create
    @question = current_user.questions.new(question_params)
    @question.save
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    flash[:notice] = 'The question is successfully deleted.'
    redirect_to questions_path
  end

  private

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

  def find_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
