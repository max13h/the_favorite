class KidsController < ApplicationController
  before_action :set_kid, only: [:show]

  def index
    @kids = Kid.where(family: current_user.family)
    authorize @kids

    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
  end

  def show
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
      redirect_to kid_path(@kid), notice: 'Kid successfully added'
    else
      render :new
    end
  end

  private

  def set_kid
    @kid = Kid.find(params[:id])
    authorize @kid
  end

  def kid_params
    params.require(:kid).permit(:name, :blood_type, :doctor_number)
  end
end
