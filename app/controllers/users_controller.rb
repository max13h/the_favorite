class UsersController < ApplicationController
  def show
    @couple = current_user.couple
    if @couple

      @nb_of_competition = @couple.competitions.count

      @user_number_of_competitions_won = @couple.competitions.where(user: current_user).count
      @rival = @couple.users.where.not(id: current_user.id).first
    end
  end
end
