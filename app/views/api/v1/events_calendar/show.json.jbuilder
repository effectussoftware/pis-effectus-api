# frozen_string_literal: true

json.events do
  json.array!(@events) do |event|
    invitation = event.invitations.find_by(user_id: current_api_v1_user.id)
    json.extract! event, :id, :name, :description, :address, :start_time, :end_time, :updated_event_at, :cancelled
    json.attend invitation.attend
    json.confirmation invitation.confirmation
  end
end
