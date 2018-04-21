class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
