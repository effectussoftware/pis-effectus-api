# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event  update endpoint', type: :request do
  let!(:user) { create(:user) }
  let!(:user_not_invited) { create(:user) }

  let!(:event) { create(:event) }

  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:auth_headers_user_not_invited) { user_not_invited.create_new_auth_token }

  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:invitation_update_attend_mobile) do
    {
      'attend' => false
    }
  end

  describe 'update value for attend' do
    context 'PUT /api/v1/events/:id with the current user invited' do
      it 'returns the value updated' do
        put api_v1_event_path(event.id), params: invitation_update_attend_mobile, headers: auth_headers_user
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['invitation']
        expect(events_response).to include(invitation_update_attend_mobile)
      end
    end

    context 'PUT /api/v1/events/:id with the current user not invited' do
      it 'returns not found' do
        put api_v1_event_path(event.id), headers: auth_headers_user_not_invited
        expect(response).to have_http_status(404)
      end
    end
  end
end
