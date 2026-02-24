class RoutineApproval < ApplicationRecord
    belongs_to :routine_execution
    belongs_to :user

    validates :routine_execution_id, uniqueness: true

    enum decision: {
        approved: 0,
        rejected: 1,
    }
end
