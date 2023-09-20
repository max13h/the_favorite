class CompetitionsController < ApplicationController
  before_action :set_competition, only: [:destroy, :show]

  def index
    @couple = current_user.couple
    @current_competition = @couple.competitions.where("end_date > ?", Time.now).first
    if @current_competition
      @competitions = @couple.competitions.where.not(id: @current_competition.id).order(end_date: :desc)
    else
      @competitions = @couple.competitions.order(end_date: :desc)
    end

  end

  def destroy
    scores = Score.where(competition: @competition)
    scores.each { |score| score.destroy }

    competitions_tasks = CompetitionsTask.where(competition: @competition)
    competitions_tasks.each { |competitions_task| competitions_task.destroy }

    events = Event.where(competition: @competition)
    events.each do |event|
      event.competition = nil
      event.save!
    end

    @competition.destroy
    redirect_to competitions_path, notice: 'Your competition was successfully deleted.'
  end

  def show
  end

  def new
    couple = current_user.couple
    current_competition = Competition.where(couple: couple).where("end_date > ?", Time.now)

    unless current_competition.empty?
      redirect_to home_path, alert: "You already have a competition running"
    end

    @default_end_date = 2.weeks.from_now.to_date
    @competition = Competition.new(couple: couple, start_date: Date.current)
  end

  def create
    @couple = current_user.couple

    @competition = Competition.new(competition_params)
    @competition.couple = @couple
    @competition.start_date = Time.now

    if @competition.save
      @couple.users.each do |user|
        @score = Score.new(competition: @competition, user: user)
        @score.save!
      end

      redirect_to competitions_path, notice: 'Competition successfully created'
    else
      render :new
    end
  end

  private

  def set_competition
    @competition = Competition.find(params[:id])
  end

  def competition_params
    params.require(:competition).permit(:end_date, :reward)
  end
end
