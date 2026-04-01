module ParentRole
  class RoutinesController < ApplicationController
    layout "parent"
    before_action :set_child

    def index
      @children = current_user.children.order(:created_at)
    end

    def new
      @routine = Routine.new
      @children = current_user.children.order(:id)
    end

    def create
      @routine = @child.routines.build(routine_params)

      if @routine.save
        redirect_to parent_role_child_routines_path(@child)
      else
        redirect_to new_parent_role_child_routine_path(@child), alert: "ルーティンの作成に失敗しました。"
      end
    end

    def destroy
      routine = @child.routines.find(params[:id])
      routine.destroy
      redirect_to parent_role_child_routines_path(@child), notice: "削除しました"
    end

    private

    def set_child
      @child = current_user.children.find(params[:child_id])
    end

    def routine_params
      params.require(:routine).permit(:title, items: [])
    end
  end
end
