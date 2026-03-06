module ChildRole
  class RoutinesController < ApplicationController
    layout "child"
    before_action :authenticate_child!

    def index
      @routines = current_child.routines
    end

    def show
      @routine = current_child.routines.find(params[:id])
    end
  end
end
