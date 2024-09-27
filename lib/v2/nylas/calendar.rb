# frozen_string_literal: true

module V2::Nylas
  # Ruby bindings for the Nylas Calendar API
  # @see https://docs.nylas.com/reference#calendars
  class Calendar
    include Model
    self.resources_path = "/calendars"
    self.creatable = true
    self.listable = true
    self.showable = true
    self.filterable = true
    self.updatable = true
    self.destroyable = true
    self.id_listable = true
    self.countable = true

    attribute :id, :string
    attribute :account_id, :string

    attribute :object, :string

    attribute :name, :string
    attribute :description, :string
    attribute :is_primary, :boolean
    attribute :location, :string
    attribute :timezone, :string

    attribute :read_only, :boolean
    attribute :metadata, :hash
    attribute :job_status_id, :string, read_only: true
    attribute :hex_color, :string, read_only: true

    def read_only?
      read_only == true
    end

    def primary?
      is_primary
    end

    def events
      api.events.where(calendar_id: id)
    end
  end
end
