# frozen_string_literal: true

json.attend invite.attend
json.confirmation invite.confirmation
json.partial! 'api/v1/admin/users/user', user: invite.user unless local_assigns[:without_user].present? && without_user
unless local_assigns[:without_event].present? && without_event
  json.partial! 'api/v1/admin/events/event', event: invite.event
end
