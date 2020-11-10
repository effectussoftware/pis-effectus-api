# frozen_string_literal: true

json.event do
  json.partial! 'event', event: @event, invitation: @invitation
end
