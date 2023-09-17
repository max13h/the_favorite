class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :root ]

  def root
    render layout: "landing"
  end

  def home
    @couple = current_user.couple
    @current_competition = @couple.competitions.where("end_date > ?", Time.now).first
    @pending_competitions_tasks = @current_competition.competitions_tasks.where(user: nil)
    @pending_events = @current_competition.events.where(user: nil)

    @user_todo = CompetitionsTask.where(is_done: false).where(competition: @current_competition).where(user: current_user)
    @user_tasks_completed = CompetitionsTask.where(is_done: true).where(competition: @current_competition).where(user: current_user)
  end

end
