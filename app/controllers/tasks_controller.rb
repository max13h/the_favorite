class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :assign_task]

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
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
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
    if @task && @task.user.nil?
      @task.user = current_user
      @task.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def mark_as_done
    @competition_task = CompetitionsTask.find(params[:id])

    if @competition_task && @competition_task.task.user == current_user
      @competition_task.is_done = true
      @competition_task.save!
    end
    redirect_back(fallback_location: root_path, anchor: 'todo')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:title, :content, :deadline, :kid, :user)
  end
end
