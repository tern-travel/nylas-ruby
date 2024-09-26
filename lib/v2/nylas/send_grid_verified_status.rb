# frozen_string_literal: true

module V2::Nylas
  # Ruby representation of a Nylas Send Grid verified status object
  # @see https://docs.nylas.com/reference#drafts
  class SendGridVerifiedStatus
    include Model::Attributable

    attribute :domain_verified, :boolean
    attribute :sender_verified, :boolean
  end
end
