class KidsController < ApplicationController
  def index
    @kids = Kid.where(family: current_user.family)

    authorize @kids
  end
end
