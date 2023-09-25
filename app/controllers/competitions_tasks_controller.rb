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

  def create_competitions_task
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    if @current_competition
      task = Task.find(params[:id])
      @competitions_task = CompetitionsTask.new(task: task, competition: @current_competition)
      authorize @competitions_task
      if @competitions_task.save
        redirect_to task_path(task), notice: 'Your task was successfully added to the commun pot.'
      else
        redirect_to common_pot_path, notice: 'Error during the creation of your task'
      end
    end
  end
end
