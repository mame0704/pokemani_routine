class RoutinesController < ApplicationController
  layout "parent"
  before_action :set_child

  def new
    @routine = @child.routines.build
  end

  def create
    @routine = @child.routines.build(routine_params)
    if @routine.save
      redirect_to child_routines_path(@child)
    else
      redirect_to new_child_routine_path(@child), alert: "ルーティンの作成に失敗しました。"
    end
  end

  private

  def set_child
    @child = current_user.children.find(params[:child_id])
  end

  def routine_params
    params.require(:routine).permit(:title, items: [])
  end
end
