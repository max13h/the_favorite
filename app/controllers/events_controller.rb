class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :assign_event]

  # GET /events
  def index
    query = "#{params[:event]} #{params[:user]} #{params[:kid]}".strip
    if query.empty?
      @events = Event.all
    else
      @events = Event.search_by_user_and_kid(query)
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/1/edit
  def edit
  end

  # GET /events/new
  def new
    @event = Event.new
    @kids = current_user.family.kids
    authorize @event
  end

  # POST /event
  def create
    @event = Event.new(event_params)
    authorize @event

    if @event.save
      redirect_to common_pot_path, notice: 'Your event was successfully added to the commun pot.'
    else
      @kids = current_user.family.kids
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Your event was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to event_url, notice: 'Your event was successfully deleted.'
  end

  def assign_event
    if @event && @event.user.nil?
      @event.user = current_user
      @event.save!
    end
    redirect_back(fallback_location: root_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
    authorize @event
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:title, :content, :date, :kid_id)
  end
end
