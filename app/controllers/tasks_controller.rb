class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  def index
    query = "#{params[:task]} #{params[:user]} #{params[:kid]}".strip
    if query.empty?
      @tasks = Task.all
    else
      @tasks = Task.search_by_user_and_kid(query)
    end
  end

  # GET /tasks/1
  def show; end

  # GET /tasks/1/edit
  def edit; end

  # GET /tasks/new
  def new
    @task = Task.new
    @kids = current_user.family.kids
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)
    kid_selected = Kid.find(params[:task][:kid].to_i)
    @task.kid = kid_selected

    if @task.save
      create_competitions_task(@task)
      redirect_to task_path(@task), notice: 'Your task was successfully added to the commun pot.'
    else
      render :new
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Your task was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to task_url, notice: 'Your task was successfully deleted.'
  end

  def assign_task
    @competition_task = CompetitionsTask.find(params[:id])

    if @competition_task && @competition_task.user.nil?
      @competition_task.user = current_user
      @competition_task.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competition_task = CompetitionsTask.find(params[:id])
    if @competition_task && @competition_task.user == current_user
      @competition_task.is_done = true
      @competition_task.save!
    end
    redirect_to increase_score_path(id: @current_competition)
  end

  def unmark_as_done
    @current_competition = Competition.find(params[:competition_id])
    @competition_task = CompetitionsTask.find(params[:id])
    if @competition_task && @competition_task.user == current_user
      @competition_task.is_done = false
      @competition_task.save!
    end
    redirect_to decrease_score_path(id: @current_competition)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :user)
  end

  def create_competitions_task(task)
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    if @current_competition
      @competitions_task = CompetitionsTask.new(task: task, competition: @current_competition)
      unless @competitions_task.save
        redirect_to common_pot_path, notice: 'Error during the creation of your task'
      end
    end
  end
end
