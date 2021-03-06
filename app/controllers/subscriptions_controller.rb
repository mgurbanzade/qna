class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.create(question: @question)
    respond_with @subscription
  end

  def destroy
    @subscription = current_user.subscriptions.find(params[:id])
    respond_with @subscription.destroy
  end
end
