module ParentRole
  class RoutineApprovalsController < ApplicationController
    layout "parent"
    before_action :authenticate_user!
    before_action :set_routine_execution, only: [:create]

    # GET /parent_role (root) → routine_approvals#new
    def new
      today = Date.current

      # 親の子どもに紐づく「今日の実行」を表示用に取得
      @routine_executions =
        RoutineExecution
          .joins(routine: :child)
          .left_outer_joins(:routine_approvals)
          .where(children: { user_id: current_user.id })
          .where(executed_on: today, status: :pending)
          .where(routine_approvals: { id: nil }) # ← 未判定（approvalなし）だけ表示
          .includes(routine: :child)
          .order(created_at: :desc)

      # ビューで form_with の model に使いたい場合のため（任意）
      @routine_approval = RoutineApproval.new
    end

    def create
      approval = @routine_execution.routine_approvals.first_or_initialize
      approval.user = current_user
      approval.decision = decision_param

      RoutineApproval.transaction do
        approval.save!

        if approval.approved?
          @routine_execution.update!(status: :completed)
        elsif approval.rejected?
          @routine_execution.update!(status: :pending)
        end
      end

      redirect_to parent_role_root_path, notice: "承認を記録しました"
    rescue ActiveRecord::RecordInvalid
      redirect_to parent_role_root_path, alert: approval.errors.full_messages.to_sentence
    end

    private

    # ✅ 認可込みで「親の子どものexecutionだけ」取る（create時のみ）
    def set_routine_execution
      @routine_execution =
        RoutineExecution
          .joins(routine: :child)
          .where(children: { user_id: current_user.id })
          .find_by(id: params[:routine_execution_id])

      unless @routine_execution
        redirect_to parent_role_root_path, alert: "対象の実行が見つかりません"
        return
      end
    end

    # decision だけ受ける
    def decision_param
      params.require(:routine_approval).fetch(:decision)
    end
  end
end
