class AnswersController < ApplicationController
  include Rated

  before_action :authenticate_user!, only: [:create, :best_answer]
  before_action :find_question, only: :create
  before_action :find_answer, only: [:update, :best_answer, :destroy]
  after_action :publish_answer, only: :create

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to edit only your own answers.'
    end
  end

  def best_answer
    if current_user.author_of?(@answer.question)
      @answer.toggle_best!
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to choose the best answer only for your own questions.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    else
      flash[:alert] = 'Action prohibited. You\'re allowed to delete only your own answers.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = @answer.attachments.map do |attach|
      { id: attach.id, filename: attach.file, url: attach.file.url }
    end

    datetime = "#{view_context.time_ago_in_words(@answer.created_at)} ago"

    data = @answer.as_json(include: :attachments).merge(answer: @answer,
      user_email: @answer.user.email,
      rating: @answer.rating,
      datetime: datetime)

    ActionCable.server.broadcast("question-#{@question.id}", data: data)
  end
end
