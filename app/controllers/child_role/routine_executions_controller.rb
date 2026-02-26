module ChildRole
  class RoutineExecutionsController < ApplicationController
    layout "child"

    def create
      routine = Routine.find(params[:routine_id])
      redirect_target = child_role_routine_path(routine) # ← どのケースでもここへ

      execution = routine.routine_executions.find_or_initialize_by(executed_on: Date.current)

      if execution.persisted?
        # 承認済みは1日1回制約：再実行不可
        if execution.completed?
          return redirect_to redirect_target, alert: "承認済みのため再実行できません"
        end

        latest_approval = execution.routine_approvals.order(created_at: :desc).first

        # 承認待ち（まだ判断がない）は再実行不可
        if latest_approval.nil?
          return redirect_to redirect_target, alert: "承認待ちのため再実行できません"
        end

        # 差し戻しのみ再実行OK
        unless latest_approval.rejected?
          return redirect_to redirect_target, alert: "再実行できません"
        end

        # 差し戻し → 再実行：承認履歴をリセット
        execution.routine_approvals.delete_all
      end

      # 実行（または再実行）したら承認待ち状態へ
      execution.status = :pending

      if execution.save
        redirect_to redirect_target, notice: "実行しました！"
      else
        redirect_to redirect_target, alert: "保存できませんでした"
      end
    end
  end
end
