class ApplicationController < ActionController::Base
  helper_method :current_child

  def current_child
    return nil unless session[:child_id]
    @current_child ||= Child.find_by(id: session[:child_id])
  end

  def after_sign_in_path_for(resource)
    parent_role_root_path
  end

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
