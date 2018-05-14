class CommentsController < ActionController::Base
  before_action :find_resource, only: :create
  after_action :publish_comment, only: :create

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast("question-#{question_id}", data: @comment.as_json )
  end

  def question_id
    @resource.is_a?(Question) ? @resource.id : @resource.question_id
  end

  def find_resource
    return @resource = Question.find(params[:question_id]) if params[:question_id]
    @resource = Answer.find(params[:answer_id]) if params[:answer_id]
  end
end
