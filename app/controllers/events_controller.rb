class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :assign_event, :unassign_event]

  def index
    query = "#{params[:event]} #{params[:user]} #{params[:kid]}".strip
    if query.empty?
      @events = Event.all
    else
      @events = Event.search_by_user_and_kid(query)
    end
  end

  def show
    @competition = Competition.find(params[:competition])
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    render layout: 'focus'
  end

  def new
    @event = Event.new
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
    @kids = current_user.family.kids
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    authorize @event

    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    @event.date = nil if @event.date > @current_competition.end_date

    if @event.save
      redirect_to common_pot_path, notice: 'Your event has been successfully added to the common pot.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
    @kids = current_user.family.kids
  end

  def update
    competition = Competition.find(params[:event][:competition_id])

    if @event.update(event_params)
      redirect_to(event_path(@event, competition: competition), notice: 'Your event was successfully updated')
    else
      @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first
      @kids = current_user.family.kids
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to event_url, notice: 'Your event was successfully deleted.'
  end

  def assign_event
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    if @event && @event.user.nil?
      @event.user = current_user
      @event.save!

      score = Score.where(user: current_user).where(competition: @current_competition).first
      score.score += 1
      score.save!
    end
    redirect_back(fallback_location: root_path)
  end

  def unassign_event
    @current_competition = current_user.family.competitions.where("end_date > ?", Time.now).first

    if @event && @event.user
      @event.user = nil
      @event.save!

      score = Score.where(user: current_user).where(competition: @current_competition).first
      score.score -= 1
      score.save!
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end

  def event_params
    params.require(:event).permit(:title, :content, :date, :kid_id, :competition_id)
  end
end
