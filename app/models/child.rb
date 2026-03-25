class Child < ApplicationRecord
  belongs_to :user
  has_many :routines, dependent: :destroy

  before_validation :set_pair_code!, on: :create

  validates :name, presence: true
  validates :pair_code, presence: true, uniqueness: true

  # 有効なルーティンだけ取得
  def active_routines
    routines.where(active: true)
  end

  private

  def set_pair_code!
    return if pair_code.present?

    # ループでユニークなコードを作る
    loop do
      self.pair_code = SecureRandom.alphanumeric(12)
      break unless Child.exists?(pair_code: pair_code)
    end
  end
end
