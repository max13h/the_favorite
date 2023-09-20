class UsersController < ApplicationController
  def show
    @family = current_user.family
    if @family

      @nb_of_competition = @family.competitions.count

      @user_number_of_competitions_won = @family.competitions.where(user: current_user).count
      @rival = @family.users.where.not(id: current_user.id).first
    end
  end
end
