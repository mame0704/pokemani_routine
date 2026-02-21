class RoutineExecution < ApplicationRecord
  belongs_to :routine
  has_many :routine_approvals, dependent: :destroy

  validates :executed_on, presence: true
  validates :routine_id, presence: true
  validates :routine_id, uniqueness: { scope: :executed_on }

  enum status: {
    pending: 0,
    approved: 1,
    rejected: 2
  }

end
