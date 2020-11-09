# frozen_string_literal: true

json.id event.id
json.name event.name
json.description event.description
json.address event.address
json.start_time event.start_time
json.end_time event.end_time
json.updated_event_at event.updated_event_at
json.cancelled event.cancelled
json.changed_last_seen event.updated_event_at < invitation.changed_last_seen if invitation.try(:changed_last_seen)
json.attend invitation.attend
json.confirmation invitation.confirmation

unless local_assigns[:without_users].present? && without_users
  json.users do
    json.partial! 'api/v1/invitations/invitation', collection: event.invitations, as: :invitation, without_event: true
  end
end
