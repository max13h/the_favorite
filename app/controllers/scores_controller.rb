class ScoresController < ApplicationController
  before_action :set_competition_and_score, only: [:increase_score, :decrease_score]

  def increase_score
    @score.score += 5
    @score.save!
    redirect_back(fallback_location: root_path, anchor: "todo")
  end

  def decrease_score
    @score.score -= 5
    @score.save!
    redirect_back(fallback_location: root_path, anchor: "todo")
  end

  private

  def set_competition_and_score
    @current_competition = Competition.find(params[:id])
    @score = Score.where(user: current_user, competition: @current_competition).first
  end
end
