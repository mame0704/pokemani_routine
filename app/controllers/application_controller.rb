class ApplicationController < ActionController::Base
  helper_method :current_child, :child_mode?, :parent_mode?

  # 親ログイン時の強制リセット
  before_action :reset_child_session_if_parent
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_child
    Child.find_by(id: session[:child_id])
  end

  def child_mode?
    Rails.logger.debug "session[:child_id] = #{session[:child_id].inspect}"
    session[:child_id].present?
  end

  def parent_mode?
    session[:child_id].blank?
  end

  def authenticate_child!
    return if child_mode?
    redirect_to new_child_session_path, alert: "こどもログインが必要です"
  end

  def after_sign_in_path_for(resource)
    parent_role_root_path
  end

  allow_browser versions: :modern

  private

  def reset_child_session_if_parent
    if user_signed_in? && !request.path.start_with?("/child_role") && session[:child_id].present?
      Rails.logger.debug "🔥 child_id RESET"
      session.delete(:child_id)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end