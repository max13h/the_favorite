class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :root ]

  def root
    render layout: "landing"
  end

  def home
    @family = current_user.family
    @current_competition = @family.competitions.where("end_date > ?", Time.now).first

    if @current_competition
      @pending_competitions_tasks = @current_competition.competitions_tasks.where(user: nil)
      @pending_events = @current_competition.events.where(user: nil)
    else
      @pending_competitions_tasks = nil
      @pending_events = nil
    end

    @user_todo = CompetitionsTask.where(is_done: false).where(competition: @current_competition).where(user: current_user)
    @user_tasks_completed = CompetitionsTask.where(is_done: true).where(competition: @current_competition).where(user: current_user)
  end

  def common_pot
    @family = current_user.family
    @current_competition = @family.competitions.where("end_date > ?", Time.now).first

    if @current_competition
      @pending_competitions_tasks = @current_competition.competitions_tasks.where(user: nil)
      @pending_events = @current_competition.events.where(user: nil)
    else
      @pending_competitions_tasks = nil
      @pending_events = nil
    end
  end
end
