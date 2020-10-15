# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event endpoint', type: :request do

  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:event) { create(:event) }

  let!(:auth_headers_user) { user.create_new_auth_token }

  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:invitation_update_attend_mobile) do
    {
      'attend' => false
    }
  end


  describe 'get event for mobile endpoint' do
    context 'GET /api/v1/events/:id with the current user invited' do
      it 'returns the event with the corresponding id' do
        get api_v1_event_path(event.id), headers: auth_headers_user
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('users')).to include(event.as_json.except('updated_at', 'created_at', 'cost'))
        expect(events_response['users'][0]['email']).to eq(user.email)
      end
    end

    context 'GET /api/v1/events/:id with the current user not invited' do
      it 'returns error 404' do
        get api_v1_event_path(event.id), headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
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
        put api_v1_event_path(event.id), headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
