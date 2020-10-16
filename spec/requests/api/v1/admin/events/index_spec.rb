# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event index endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'GET /api/v1/admin/events' do
    context 'returns the two pre-existing events' do
      let!(:event) { create(:event) }
      let!(:event_to_update) { create(:event) }
      let!(:invitation) { create(:invitation, user: user, event: event) }
      it 'returns 200 ok with a list of events' do
        get api_v1_admin_events_path, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']
        expect(events_response[0].except('users')).to include(event.as_json.except('updated_at', 'created_at'))
        expect(events_response[0]['users'][0]['id']).to eq(invitation.as_json['user_id'])
        expect(events_response[1].except('users')).to include event_to_update.as_json.except('updated_at', 'created_at')
      end
    end
    context 'without events' do
      it 'returns 200 ok with a empty list of eventos' do
        get api_v1_admin_events_path, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']
        expect(events_response).to match_array([])
      end
    end
  end
end
