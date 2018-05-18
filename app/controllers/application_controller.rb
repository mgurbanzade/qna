class ApplicationController < ActionController::Base
  before_action :gon_user

  authorize_resource unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
      format.json { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
    gon.user_signed_in = user_signed_in?
  end
end
