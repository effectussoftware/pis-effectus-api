# frozen_string_literal: true

json.partial! 'api/v1/users/user', user: invitation.user unless local_assigns[:without_user].present? && without_user
unless local_assigns[:without_event].present? && without_event
  json.event do
    json.partial! 'api/v1/events/event', event: invitation.event
  end
end
json.attend invitation.attend
json.confirmation invitation.confirmation
