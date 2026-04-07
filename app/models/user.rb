class User < ApplicationRecord
  # Devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :children, dependent: :destroy
  has_many :routine_approvals, dependent: :destroy

  # Role管理（親・子）
  enum role: { parent: 0, child: 1 }

end