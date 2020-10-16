# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event show endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:event) { create(:event) }
  let!(:invitation) { create(:invitation, user: user, event: event) }

  describe 'GET /api/v1/admin/events/id' do
    context 'event with id' do
      it 'returns the event with the corresponding id' do
        get api_v1_admin_event_path(event.id), headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('users')).to include(event.as_json.except('updated_at', 'created_at'))
        expect(events_response['users'][0]['id']).to eq(invitation.as_json['user_id'])
      end

      it 'returns not_found' do
        highest_id = Event.last.id + 1
        get api_v1_admin_event_path(highest_id), headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
