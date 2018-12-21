class RecurringEvent < ApplicationRecord
  has_many :events, inverse_of: :recurring_event
  after_save :update_events
  validates_presence_of :start_date, :end_date, :frequency, :name, :start_time,
                        :duration_minutes
  validates :end_date, date: {after_or_equal_to: :start_date}
  enum frequency: %i[daily weekly monthly quarterly]

  EVENT_FIELDS = %w[name start_time duration_minutes]
  FREQUENCY_MAP = {
    daily: 1,
    weekly: 7,
    # Note months won't completely work, since they return a number of days,
    # which will vary depending on the month
    monthly: 1.month / 1.day,
    quarterly: 3.months / 1.day
  }.with_indifferent_access.freeze

  def update_events
    update_event_properties
    remove_old_events
    add_new_events
  end

  def update_event_properties
    changed_props = saved_changes.keys & EVENT_FIELDS
    return if changed_props.empty?

    event_changes = saved_changes.slice(*changed_props)
    old_props = event_changes.map {|prop, val| {prop => val.first}}.reduce(:merge)
    new_props = attributes.slice(*changed_props)
    events.where(old_props).update_all(new_props)
  end

  private

  def remove_old_events
    remove_dates = old_dates - new_dates
    return if remove_dates.empty?

    events.where(date: remove_dates).delete_all
  end

  def add_new_events
    add_dates = new_dates - old_dates
    new_events = add_dates.map {|date|
      attributes.slice(*EVENT_FIELDS).merge(date: date)
    }
    events.create!(new_events)
  end

  def new_dates
    interval = FREQUENCY_MAP[frequency]
    (start_date..end_date).step(interval).to_a
  end

  def old_dates
    events.pluck(:date)
  end
end
