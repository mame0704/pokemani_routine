class Routine < ApplicationRecord
  belongs_to :child
  has_many :routine_executions, dependent: :destroy
  serialize :items, coder: JSON, type: Array

  validates :title, presence: true
  attribute :active, :boolean, default: true

# ルーティンのactive状態をDB上で反転させるスイッチメソッド
  def toggle!
    update!(active: !active)
  end
end
