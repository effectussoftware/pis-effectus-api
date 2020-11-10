# frozen_string_literal: true

unless local_assigns[:without_user].present? && without_user
  json.partial! 'api/v1/admin/users/user', user: invitation.user
end
unless local_assigns[:without_event].present? && without_event
  json.partial! 'api/v1/admin/events/event', event: invitation.event
end
json.attend invitation.attend
json.confirmation invitation.confirmation
