class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

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
  def show; end

  # GET /events/1/edit
  def edit; end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /event
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to event_path(@event), notice: 'Your event was successfully added to the commun pot.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Your event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to event_url, notice: 'Your event was successfully deleted.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:title, :content, :date, :kid, :user)
  end
end
