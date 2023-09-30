class CompetitionsTasksController < ApplicationController

  def assign_task
    @competition_task = CompetitionsTask.find(params[:id])
    authorize @competition_task

    if @competition_task && @competition_task.user.nil?
      @competition_task.user = current_user
      @competition_task.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competition_task = CompetitionsTask.find(params[:id])
    authorize @competition_task
    if @competition_task && @competition_task.user == current_user
      @competition_task.is_done = true
      @competition_task.save!
    end
    redirect_to increase_score_path(id: @current_competition)
  end

  def unmark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competition_task = CompetitionsTask.find(params[:id])
    authorize @competition_task
    if @competition_task && @competition_task.user == current_user
      @competition_task.is_done = false
      @competition_task.save!
    end
    redirect_to decrease_score_path(id: @current_competition)
  end

end
