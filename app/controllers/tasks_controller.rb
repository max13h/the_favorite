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
      redirect_to common_pot_path
    else
      @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
      render :new, status: :unprocessable_entity
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

  private

  def set_task
    @task = Task.find(params[:id])
    authorize @task
  end

  def task_params
    params.require(:task).permit(:title, :content, :kid_id, competitions_tasks_attributes: [:deadline, :competition_id])
  end
end
