class ChildSessionsController < ApplicationController
  layout "child"

  def new
  end

  def create
    pair_code = params[:pair_code].to_s.strip
    child = Child.find_by(pair_code: pair_code)

    if child
        Rails.logger.debug("=== login ok child_id=#{child.id}")
        Rails.logger.debug("=== session before: #{session.to_hash}")
        session[:child_id] = child.id
        Rails.logger.debug("=== session after: #{session.to_hash}")

        routine = child.routines.order(:id).first
        if routine
        redirect_to child_role_routine_path(routine), notice: "こどもログインしました"
        else
        redirect_to child_role_routines_path, alert: "ルーティンがまだありません"
        end
    else
        flash.now[:alert] = "ペアコードが違います"
        render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:child_id)
    redirect_to root_path, notice: "ログアウトしました"
  end
end
