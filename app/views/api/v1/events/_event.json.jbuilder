# frozen_string_literal: true

json.extract! event, :id, :name, :address, :start_time, :end_time, :updated_event_at, :cancelled, :updated_at

json.users do
  json.partial! 'api/v1/invitations/invitation', collection: event.invitations, as: :invitation, without_event: true
end
