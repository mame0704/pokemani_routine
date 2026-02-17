class Child < ApplicationRecord
  belongs_to :user
  has_many :routines, dependent: :destroy

  validates :name, presence: true
  validates :pair_code, uniqueness: true, allow_nil: true

  # 有効なルーティンだけ取得する
  def active_routines
    routines.where(active: true)
  end
end
