module ParentRole
  class AccountsController < ApplicationController
    layout "parent"
    before_action :authenticate_user!

    def index
      @children = current_user.children.order(:created_at)
    end

    def show
      @child = current_user.children.find(params[:child_id])
      @routine = @child.routines.find(params[:id])
    end

    def edit
      @child = current_user.children.find(params[:id])
    end

    def update
      @child = current_user.children.find(params[:id])

      if @child.update(child_params)
        redirect_to parent_role_accounts_path, notice: "名前を更新しました"
      else
        render :edit
      end
    end

    # ペアID発行（= 子ども追加）
    def create
      next_number = current_user.children.count + 1
      child = current_user.children.build(name: "こども#{next_number}")

      if child.save
        redirect_to parent_role_accounts_path, notice: "ペアIDを発行しました"
      else
        redirect_to parent_role_accounts_path, alert: "ペアIDの発行に失敗しました"
      end
    end

    def destroy
      child = current_user.children.find(params[:id])
      child.destroy!
      redirect_to parent_role_accounts_path, notice: "ペアIDを削除しました"
    end

    private

    def child_params
      params.require(:child).permit(:name)
    end
  end
end
