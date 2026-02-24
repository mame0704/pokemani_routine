module ParentRole
  class RoutineApprovalsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_routine_execution, only: [:create]

    # GET /parent_role (root) → routine_approvals#new
    def new
      today = Date.current

      # 親の子どもに紐づく「今日の実行」を表示用に取得
      @routine_executions =
        RoutineExecution
          .joins(routine: :child)
          .where(children: { user_id: current_user.id })
          .where(executed_on: today)
          .includes(routine: :child)
          .order(created_at: :desc)

      # ビューで form_with の model に使いたい場合のため（任意）
      @routine_approval = RoutineApproval.new
    end

    # POST /parent_role/routine_executions/:routine_execution_id/routine_approvals
    def create
      approval = @routine_execution.routine_approvals.build(
        user: current_user,
        decision: decision_param
      )

      if approval.save
        redirect_to parent_role_root_path, notice: "承認を記録しました"
      else
        redirect_to parent_role_root_path, alert: approval.errors.full_messages.to_sentence
      end
    end

    private

    # ✅ 認可込みで「親の子どものexecutionだけ」取る（create時のみ）
    def set_routine_execution
      @routine_execution =
        RoutineExecution
          .joins(routine: :child)
          .where(children: { user_id: current_user.id })
          .find(params[:routine_execution_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to parent_role_root_path, alert: "対象の実行が見つかりません"
    end

    # decision だけ受ける
    def decision_param
      params.require(:routine_approval).fetch(:decision)
    end
  end
end
