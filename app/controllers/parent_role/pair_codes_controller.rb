# app/controllers/parent_role/pair_codes_controller.rb
module ParentRole
  class PairCodesController < ApplicationController
    layout "parent"
    before_action :authenticate_user!

    def update
      child = current_user.children.find(params[:child_id])

      child.update!(pair_code: generate_unique_pair_code)

      redirect_to parent_role_children_path, notice: "ペアIDを再発行しました"
    end

    private

    def generate_unique_pair_code
      loop do
        code = SecureRandom.alphanumeric(10)
        break code unless Child.exists?(pair_code: code)
      end
    end
  end
end
