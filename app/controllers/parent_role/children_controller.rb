module ParentRole
  class ChildrenController < ApplicationController
    layout "parent"
    before_action :authenticate_user!

    def index
      @children = current_user.children.order(:created_at)
    end

    def show
      @child = current_user.children.find(params[:child_id])
      @routine = @child.routines.find(params[:id])
    end

    def edit
      @child = current_user.children.find(params[:id])
    end

    def update
      @child = current_user.children.find(params[:id])
    end

    private

    def child_params
      params.require(:child).permit(:name)
    end
  end
end
