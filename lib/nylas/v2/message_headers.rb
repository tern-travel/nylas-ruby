# frozen_string_literal: true

module Nylas::V2
  # Translates message headers into a Ruby object
  # @see https://docs.nylas.com/reference#section-message-views
  class MessageHeaders
    include Model::Attributable
    attribute :in_reply_to, :string
    attribute :message_id, :string
    has_n_of_attribute :references, :string
  end

  # Serializes, Deserializes between {MessageHeaders} objects and a Hash
  class MessageHeadersType < Types::ModelType
    def initialize
      super(model: MessageHeaders)
    end
    RUBY_KEY_TO_JSON_KEY_MAP = {
      in_reply_to: :"In-Reply-To",
      message_id: :"Message-Id",
      references: :References
    }.freeze
    def json_key_from_attribute_name(attribute_name)
      RUBY_KEY_TO_JSON_KEY_MAP.fetch(attribute_name)
    end
  end
end
