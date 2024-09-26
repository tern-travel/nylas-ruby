# frozen_string_literal: true

module V2::Nylas
  # Message tracking features
  # @see https://docs.nylas.com/reference#message-tracking-overview
  class MessageTracking
    include Model::Attributable
    attribute :links, :boolean
    attribute :opens, :boolean
    attribute :thread_replies, :boolean
    attribute :payload, :string
  end
end
