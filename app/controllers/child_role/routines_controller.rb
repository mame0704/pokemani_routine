module ChildRole
  class RoutinesController < ApplicationController
    layout "child"

    def index
      @routines = current_user.children.first.routines
    end

    def show
      @routine = Routine.find(params[:id])
    end

  end
end
