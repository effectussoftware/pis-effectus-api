# frozen_string_literal: true

json.invitation do
  json.partial! 'api/v1/invitations/invitation',
                invitation: @invitation,
                without_user: true,
                without_event: true
end
