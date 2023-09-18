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
    redirect_to competitions_path, notice: 'Your task was successfully deleted.'
  end

  def show
  end

  private

  def set_competition
    @competition = Competition.find(params[:id])
  end
end
