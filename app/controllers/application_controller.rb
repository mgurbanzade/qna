class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, alert: exception.message }
      format.js   { head :forbidden }
      format.json { head :forbidden }
    end
  end

  private

  def gon_user
    gon.user_id = current_user.id if user_signed_in?
    gon.user_signed_in = user_signed_in?
  end
end
