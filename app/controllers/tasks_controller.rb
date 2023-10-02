class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :mark_as_recurent, :unmark_as_recurent]

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
  def show
    @competition = Competition.find(params[:competition])
    @competitions_task = CompetitionsTask.where(task: @task, competition: @competition).first

    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    render layout: 'focus'
  end

  # GET /tasks/1/edit


  # GET /tasks/new
  def new
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    unless @current_competition
      redirect_back(fallback_location: root_path, alert: 'You need to start a competition.')
    end

    @task = Task.new
    @task.competitions_tasks.build
    authorize @task
    @kids = current_user.family.kids
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    unless task_params[:kid_id].empty?
      kid_selected = Kid.find(task_params[:kid_id])
      @task.kid = kid_selected
    end

    authorize @task
    if @task.save
      redirect_to common_pot_path, notice: 'Your task has been successfully added to the common pot.'
    else
      @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
    @kids = current_user.family.kids
  end

  # PATCH/PUT /tasks/1
  def update
    competition = Competition.find(params[:task][:competition_id])

    if @task.update(task_params)
      redirect_to(task_path(@task, competition: competition), notice: 'Your task was successfully updated')
    else
      render :edit
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
    redirect_to task_url, notice: 'Your task was successfully deleted.'
  end

  def mark_as_recurent
    @task.is_recurent = true

    if @task.save
      redirect_back(fallback_location: root_path, notice: "Task successfully marked as recurent")
    else
      redirect_back(fallback_location: root_path, alert: "Error, something went wrong")
    end
  end

  def unmark_as_recurent
    @task.is_recurent = false

    if @task.save
      redirect_back(fallback_location: root_path, notice: "Task successfully unmarked as recurent")
    else
      redirect_back(fallback_location: root_path, alert: "Error, something went wrong")
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
    authorize @task
  end

  def task_params
    params.require(:task).permit(:title, :content, :kid_id, competitions_tasks_attributes: [:deadline, :competition_id])
  end
end
