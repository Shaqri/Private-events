class EventsController < ApplicationController
  include ApplicationHelper
  before_action :require_login, except: %i[index show]
  def new
    @event = Event.new
  end

  def index
    @events = Event.all
    @upcomming_events = Event.upcomming
    @prev_events = Event.past
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      EventMailer.with(event: @event).event_created.deliver_later

      redirect_to current_user, notice: 'Event created'
    else
      flash.now[:alert] = 'Invalid event'
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @user_options = User.all.map { |u| [u.name, u.id] }
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to user_path(current_user), notice: 'Event updated'
    else
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to user_path(current_user), notice: 'Event successfully deleted'
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :location, :date)
  end

  def require_login
    return if user_logged_in?

    flash[:alert] = 'You must be logged in to create a new event'
    redirect_to root_path
  end
end
