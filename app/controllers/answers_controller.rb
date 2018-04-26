class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :find_question, only: [:create, :destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'The answer is successfully deleted.'
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to delete only your own answers.'
    end
    redirect_to @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
