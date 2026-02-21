module ChildRole
  class RoutineExecutionsController < ApplicationController
    layout "child"

    def create
      routine = Routine.find(params[:routine_id])

      execution = routine.routine_executions.find_or_initialize_by(executed_on: Date.current)

      execution.status ||= :pending

      if execution.save
        redirect_back fallback_location: root_path, notice: "実行しました！"
      else
        redirect_back fallback_location: root_path, alert: "保存できませんでした"
      end
    end
  end
end
