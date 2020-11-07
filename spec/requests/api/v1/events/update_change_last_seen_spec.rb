# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event update_change_last_seen endpoint', type: :request do
  let!(:user) { create(:user) }
  let!(:user_not_invited) { create(:user) }

  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:auth_headers_user_not_invited) { user_not_invited.create_new_auth_token }

  let!(:event) { create(:event) }
  let!(:invitation) { create(:invitation, user: user, event: event) }

  describe 'PUT /api/v1/invitations/:id/update_change_last_seen' do
    context 'with the current user invited' do
      it 'updates the change_last_seen' do
        Timecop.freeze(Date.today - 1.hour) do
          invitation.update(changed_last_seen: Time.zone.now)
        end
        Timecop.freeze(Date.today) do
          put update_change_last_seen_api_v1_invitation_path(id: event.id), headers: auth_headers_user
          invitation.reload
          expect(response).to have_http_status(200)
          expect(invitation.changed_last_seen).to eq(Time.zone.now)
        end
      end
    end

    context 'with the current user not invited' do
      it 'returns error 404' do
        put update_change_last_seen_api_v1_invitation_path(id: event.id), headers: auth_headers_user_not_invited
        expect(response).to have_http_status(404)
      end
    end
  end
end
