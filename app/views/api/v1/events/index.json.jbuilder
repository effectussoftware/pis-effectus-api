# frozen_string_literal: true

json.events do
  json.array!(@events) do |event|
    json.partial! 'api/v1/events/event', event: event,
                                         invitation: event.invitations.find_by(user_id: current_api_v1_user.id),
                                         without_users: true
  end
end
