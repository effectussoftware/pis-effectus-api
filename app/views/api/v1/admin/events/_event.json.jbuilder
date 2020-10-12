# frozen_string_literal: true

json.extract! event, :id, :name, :address, :start_time, :cost, :cancelled

json.users do
  json.partial! 'api/v1/admin/invitations/invitation', collection: event.invitations, as: :invitation, without_event: true
end
