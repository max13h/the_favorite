class KidsController < ApplicationController
  before_action :set_kid, only: [:show, :edit]

  def index
    @kids = Kid.where(family: current_user.family)
    authorize @kids

    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
  end

  def show
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    @competitions_tasks = CompetitionsTask.joins(task: :kid).where(competition: @current_competition, tasks: { kid: @kid })
    @events = Event.where(kid: @kid).where('date > ?', DateTime.current)

    render layout: "focus"
  end

  def new
    @kid = Kid.new
    authorize @kid
  end

  def create
    @kid = Kid.new(kid_params)
    authorize @kid
    @kid.family = current_user.family

    if @kid.save
      redirect_to kid_path(@kid), notice: 'Kid successfully added to your family'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @kid.update(kid_params)
      redirect_to @kid, notice: "Your kid's informations were successfully updated."
      authorize @kid
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_kid
    @kid = Kid.find(params[:id])
    authorize @kid
  end

  def kid_params
    params.require(:kid).permit(:name, :blood_type, :doctor_number, :picture)
  end
end
