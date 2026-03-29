# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

    # パスワードが空なら削除
    if params[resource_name][:password].blank?
      params[resource_name].delete(:password)
      params[resource_name].delete(:password_confirmation)
    end

    # current_passwordも不要なので削除
    params[resource_name].delete(:current_password)

    # パスワードなしで更新
    if resource.update_without_password(account_update_params)
      redirect_to after_update_path_for(resource), notice: "更新しました"
    else
      render :edit
    end
  end

  protected

  def after_update_path_for(resource)
    user_profile_path(current_user)
  end

end
