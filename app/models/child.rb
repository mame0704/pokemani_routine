class Child < ApplicationRecord
  belongs_to :user
  has_many :routines, dependent: :destroy

  before_create :set_pair_code!

  validates :name, presence: true
  validates :pair_code, uniqueness: true, allow_nil: true

  # 有効なルーティンだけ取得する
  def active_routines
    routines.where(active: true)
  end

  private

  def set_pair_code!
    return if pair_code.present?

    loop do
      self.pair_code = SecureRandom.alphanumeric(12)
      break unless Child.exists?(pair_code: pair_code)
    end
  end
end
