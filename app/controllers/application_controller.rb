class ApplicationController < ActionController::Base
  helper_method :current_child, :child_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def current_child
    return nil unless session[:child_id]
    @current_child ||= Child.find_by(id: session[:child_id])
  end

  def child_signed_in?
    current_child.present?
  end

  # 子ども画面用：ログイン必須ガード（MVP版）
  def authenticate_child!
    return if child_signed_in?
    redirect_to new_child_session_path, alert: "こどもログインが必要です"
  end

  def after_sign_in_path_for(resource)
    parent_role_root_path
  end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def configure_permitted_parameters
    # 新規登録時にnicknameの取得を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    # 情報更新時にnicknameの取得を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end
end
