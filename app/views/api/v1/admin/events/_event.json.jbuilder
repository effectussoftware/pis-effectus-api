# frozen_string_literal: true

json.extract! event, :id, :name, :address, :start_time, :cost

json.users do
  json.partial! 'api/v1/admin/invites/invite', collection: event.invites, as: :invite, without_event: true
end
