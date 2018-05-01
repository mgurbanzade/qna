class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :update, :destroy]

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
    if current_user.author_of?(@question)
      @question.update(question_params)
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to edit only your own questions.'
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'The question is successfully deleted.'
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to delete only your own questions.'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
