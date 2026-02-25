module ParentRole
  class ChildrenController < ApplicationController
    before_action :authenticate_user!

    def index
      @children = current_user.children.order(:created_at)
    end

    # ペアID発行（= 子ども追加）
    def create
      next_number = current_user.children.count + 1
      child = current_user.children.build(name: "こども#{next_number}")

      if child.save
        redirect_to parent_role_children_path, notice: "ペアIDを発行しました"
      else
        redirect_to parent_role_children_path, alert: "ペアIDの発行に失敗しました"
      end
    end

    def destroy
      child = current_user.children.find(params[:id])
      child.destroy!
      redirect_to parent_role_children_path, notice: "ペアIDを削除しました"
    end
  end
end
