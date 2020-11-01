# frozen_string_literal: true

json.extract! event, :id, :name, :address, :start_time, :end_time, :cost, :cancelled, :updated_event_at, :invitations

# json.users do
#   json.partial! 'api/v1/admin/invitations/invitation', collection: event.invitations, as: :invitation, without_event: true
# end
