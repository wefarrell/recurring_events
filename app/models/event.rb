class Event < ApplicationRecord
  belongs_to :recurring_event, optional: true
  attr_accessor :recurring_event_updates
  after_save :update_recurring_events, if: :recurring_event_updates

  def update_recurring_events
    if recurring_event
      recurring_event.update!(recurring_event_updates)
    else
      params = recurring_event_updates.merge(events: [self])
      RecurringEvent.create!(params)
    end
  end
end
