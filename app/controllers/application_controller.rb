class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  before_action :set_current_user

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def set_current_user
    @_current_user ||= User.find_by(id: cookies.signed[:user_id])

    if @_current_user.blank?
      @_current_user = User.create!

      cookies.signed[:user_id] = {
        value: @_current_user.id,
        expires: 20.years.from_now
      }
    end
  end

  def current_user
    @_current_user
  end
  helper_method :current_user

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path, status: :see_other)
  end
end
