# frozen_string_literal: true

module V2::Nylas
  # Query free/busy information for a calendar during a certain time period
  # @see https://docs.nylas.com/reference#calendars-free-busy
  class TimeSlot
    include Model::Attributable

    attribute :object, :string
    attribute :status, :string
    attribute :start_time, :unix_timestamp
    attribute :end_time, :unix_timestamp
    attribute :capacity, :time_slot_capacity
    has_n_of_attribute :emails, :string
  end
end
