# frozen_string_literal: true

puts "*" * 100
puts "LOADING nylas.rb FILE"

require "json"
require "rest-client"

# BUGFIX
#   See https://github.com/sparklemotion/http-cookie/issues/27
#   and https://github.com/sparklemotion/http-cookie/issues/6
#
# CookieJar uses unsafe class caching for dynamically loading cookie jars
# If 2 rest-client instances are instantiated at the same time, (in threads)
# non-deterministic behaviour can occur whereby the Hash cookie jar isn't
# properly loaded and cached.
# Forcing an instantiation of the jar onload will force the CookieJar to load
# before the system has a chance to spawn any threads.
# Note this should technically be fixed in rest-client itself however that
# library appears to be stagnant so we're forced to fix it here
# This object should get GC'd as it's not referenced by anything
HTTP::CookieJar.new

require "ostruct"
require "forwardable"

require_relative "v2/nylas/version"
require_relative "v2/nylas/errors"

require_relative "v2/nylas/logging"
require_relative "v2/nylas/registry"
require_relative "v2/nylas/types"
require_relative "v2/nylas/constraints"

require_relative "v2/nylas/http_client"
require_relative "v2/nylas/api"
require_relative "v2/nylas/collection"
require_relative "v2/nylas/model"

# Attribute types supported by the API
require_relative "v2/nylas/email_address"
require_relative "v2/nylas/event"
require_relative "v2/nylas/file"
require_relative "v2/nylas/folder"
require_relative "v2/nylas/im_address"
require_relative "v2/nylas/label"
require_relative "v2/nylas/message_headers"
require_relative "v2/nylas/message_tracking"
require_relative "v2/nylas/participant"
require_relative "v2/nylas/physical_address"
require_relative "v2/nylas/phone_number"
require_relative "v2/nylas/recurrence"
require_relative "v2/nylas/rsvp"
require_relative "v2/nylas/timespan"
require_relative "v2/nylas/web_page"
require_relative "v2/nylas/nylas_date"
require_relative "v2/nylas/when"
require_relative "v2/nylas/free_busy"
require_relative "v2/nylas/time_slot"
require_relative "v2/nylas/time_slot_capacity"
require_relative "v2/nylas/open_hours"
require_relative "v2/nylas/event_conferencing"
require_relative "v2/nylas/event_conferencing_details"
require_relative "v2/nylas/event_conferencing_autocreate"
require_relative "v2/nylas/event_notification"
require_relative "v2/nylas/component"

# Custom collection types
require_relative "v2/nylas/event_collection"
require_relative "v2/nylas/search_collection"
require_relative "v2/nylas/deltas_collection"
require_relative "v2/nylas/free_busy_collection"
require_relative "v2/nylas/calendar_collection"
require_relative "v2/nylas/component_collection"
require_relative "v2/nylas/scheduler_collection"
require_relative "v2/nylas/job_status_collection"
require_relative "v2/nylas/outbox"

# Models supported by the API
require_relative "v2/nylas/account"
require_relative "v2/nylas/calendar"
require_relative "v2/nylas/contact"
require_relative "v2/nylas/contact_group"
require_relative "v2/nylas/current_account"
require_relative "v2/nylas/deltas"
require_relative "v2/nylas/delta"
require_relative "v2/nylas/draft"
require_relative "v2/nylas/message"
require_relative "v2/nylas/room_resource"
require_relative "v2/nylas/new_message"
require_relative "v2/nylas/raw_message"
require_relative "v2/nylas/thread"
require_relative "v2/nylas/webhook"
require_relative "v2/nylas/scheduler"
require_relative "v2/nylas/job_status"
require_relative "v2/nylas/token_info"
require_relative "v2/nylas/application_details"
require_relative "v2/nylas/outbox_message"
require_relative "v2/nylas/outbox_job_status"
require_relative "v2/nylas/send_grid_verified_status"

# Neural specific types
require_relative "v2/nylas/neural"
require_relative "v2/nylas/neural_sentiment_analysis"
require_relative "v2/nylas/neural_ocr"
require_relative "v2/nylas/neural_categorizer"
require_relative "v2/nylas/neural_clean_conversation"
require_relative "v2/nylas/neural_contact_link"
require_relative "v2/nylas/neural_contact_name"
require_relative "v2/nylas/neural_signature_contact"
require_relative "v2/nylas/neural_signature_extraction"
require_relative "v2/nylas/neural_message_options"
require_relative "v2/nylas/categorize"
require_relative "v2/nylas/scheduler_config"
require_relative "v2/nylas/scheduler_time_slot"
require_relative "v2/nylas/scheduler_booking_request"
require_relative "v2/nylas/scheduler_booking_confirmation"

require_relative "v2/nylas/native_authentication"

require_relative "v2/nylas/filter_attributes"

require_relative "v2/nylas/services/tunnel"
# an SDK for interacting with the Nylas API
# @see https://docs.nylas.com/reference
module V2::Nylas
  Types.registry[:account] = Types::ModelType.new(model: Account)
  Types.registry[:calendar] = Types::ModelType.new(model: Calendar)
  Types.registry[:contact] = Types::ModelType.new(model: Contact)
  Types.registry[:delta] = DeltaType.new
  Types.registry[:draft] = Types::ModelType.new(model: Draft)
  Types.registry[:email_address] = Types::ModelType.new(model: EmailAddress)
  Types.registry[:event] = Types::ModelType.new(model: Event)
  Types.registry[:file] = Types::ModelType.new(model: File)
  Types.registry[:folder] = Types::ModelType.new(model: Folder)
  Types.registry[:im_address] = Types::ModelType.new(model: IMAddress)
  Types.registry[:label] = Types::ModelType.new(model: Label)
  Types.registry[:room_resource] = Types::ModelType.new(model: RoomResource)
  Types.registry[:message] = Types::ModelType.new(model: Message)
  Types.registry[:message_headers] = MessageHeadersType.new
  Types.registry[:message_tracking] = Types::ModelType.new(model: MessageTracking)
  Types.registry[:participant] = Types::ModelType.new(model: Participant)
  Types.registry[:physical_address] = Types::ModelType.new(model: PhysicalAddress)
  Types.registry[:phone_number] = Types::ModelType.new(model: PhoneNumber)
  Types.registry[:recurrence] = Types::ModelType.new(model: Recurrence)
  Types.registry[:thread] = Types::ModelType.new(model: Thread)
  Types.registry[:timespan] = Types::ModelType.new(model: Timespan)
  Types.registry[:web_page] = Types::ModelType.new(model: WebPage)
  Types.registry[:nylas_date] = NylasDateType.new
  Types.registry[:contact_group] = Types::ModelType.new(model: ContactGroup)
  Types.registry[:when] = Types::ModelType.new(model: When)
  Types.registry[:time_slot] = Types::ModelType.new(model: TimeSlot)
  Types.registry[:time_slot_capacity] = Types::ModelType.new(model: TimeSlotCapacity)
  Types.registry[:event_conferencing] = Types::ModelType.new(model: EventConferencing)
  Types.registry[:event_conferencing_details] = Types::ModelType.new(model: EventConferencingDetails)
  Types.registry[:event_conferencing_autocreate] = Types::ModelType.new(model: EventConferencingAutocreate)
  Types.registry[:event_notification] = Types::ModelType.new(model: EventNotification)
  Types.registry[:neural] = Types::ModelType.new(model: Neural)
  Types.registry[:categorize] = Types::ModelType.new(model: Categorize)
  Types.registry[:neural_signature_contact] = Types::ModelType.new(model: NeuralSignatureContact)
  Types.registry[:neural_contact_link] = Types::ModelType.new(model: NeuralContactLink)
  Types.registry[:neural_contact_name] = Types::ModelType.new(model: NeuralContactName)
  Types.registry[:scheduler_config] = Types::ModelType.new(model: SchedulerConfig)
  Types.registry[:scheduler_time_slot] = Types::ModelType.new(model: SchedulerTimeSlot)
  Types.registry[:job_status] = Types::ModelType.new(model: JobStatus)
  Types.registry[:outbox_message] = Types::ModelType.new(model: OutboxMessage)
end
