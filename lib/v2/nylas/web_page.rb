# frozen_string_literal: true

module V2::Nylas
  # Structure to represent the Web Page Schema
  # @see https://docs.nylas.com/reference#contactsid
  class WebPage
    include Model::Attributable
    attribute :type, :string
    attribute :url, :string
  end
end
