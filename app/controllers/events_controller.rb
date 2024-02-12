class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.all
  end

  def event_a
    @event = current_user.events.build(event_params)

    event_response(@event, "event a")

    redirect_to root_path
  end

  def event_b
    @event = current_user.events.build(event_params)

    if event_response(@event, "event b")
      send_email_notification(current_user, @event)
      flash[:notice] = "Email notification sent Successfully"
    end

    redirect_to root_path
  end

  private

  def event_params
    params.require(:event).permit(:title)
  end

  def event_response(event, message)
    if event.save
      flash[:notice] = "#{message} created successfully"
      IterableService.send_event(event.title, current_user)
    else
      flash[:alert] = event.errors.any? ? event.errors.full_messages :  "something went wrong"
    end
  end

  def send_email_notification(user, event)
    IterableService.send_email(user, event)
  end
end
