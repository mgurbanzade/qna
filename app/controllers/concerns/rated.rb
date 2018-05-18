module Rated
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:like, :dislike]
  end

  def like
    @resource.toggle_like(current_user)
    render_json(@resource.vote_type(current_user))
  end

  def dislike
    @resource.toggle_dislike(current_user)
    render_json(@resource.vote_type(current_user))
  end

  private

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json(action)
    render json: { id: @resource.id, klass: @resource.class.to_s,  action: action, rating: @resource.rating }
  end
end
