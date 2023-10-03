class CompetitionsTasksController < ApplicationController
  before_action :set_competitions_task, only: [:edit, :update, :destroy]

  def assign_task
    @competitions_task = CompetitionsTask.find(params[:id])
    authorize @competitions_task

    if @competitions_task && @competitions_task.user.nil?
      @competitions_task.user = current_user
      @competitions_task.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def unassign_task
    @competitions_task = CompetitionsTask.find(params[:id])
    authorize @competitions_task

    if @competitions_task && @competitions_task.user
      @competitions_task.user = nil
      @competitions_task.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competitions_task = CompetitionsTask.find(params[:id])
    authorize @competitions_task
    if @competitions_task && @competitions_task.user == current_user
      @competitions_task.is_done = true
      @competitions_task.save!
    end
    redirect_to increase_score_path(id: @current_competition)
  end

  def unmark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competitions_task = CompetitionsTask.find(params[:id])
    authorize @competitions_task
    if @competitions_task && @competitions_task.user == current_user
      @competitions_task.is_done = false
      @competitions_task.save!
    end
    redirect_to decrease_score_path(id: @current_competition)
  end

  def edit
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
  end

  def update
    competition = Competition.find(params[:competitions_task][:competition_id])

    if @competitions_task.update(competitions_task_params)
      redirect_to task_path(@competitions_task.task, competition: competition), notice: "Your task's deadline has been successfully updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_competitions_task
    @competitions_task = CompetitionsTask.find(params[:id])
    authorize @competitions_task
  end

  def competitions_task_params
    params.require(:competitions_task).permit(:deadline)
  end
end
