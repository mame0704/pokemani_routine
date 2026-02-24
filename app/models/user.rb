class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :children, dependent: :destroy
  has_many :routine_approvals, dependent: :destroy

  # DBに子がいるかチェックし、いる場合は親とみなす
  def parent?
    children.exists?
  end
end
