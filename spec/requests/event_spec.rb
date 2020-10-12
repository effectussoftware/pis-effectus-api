# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event endpoint', type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:invitation) { create(:invitation, user: user, event: event) }
  let!(:event_to_create_with_user) do
    {
      'event' =>
        {
          'name' => 'evento_testing',
          'address' => 'testing_address333',
          'date' => '2020-09-02T00:00:00.000Z',
          'cost' => 200,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'duration' => '2020-10-07T01:00:00.000Z'

        },
      'users' => [{
        'id' => user.id
      }]
    }
  end
  let!(:event_to_create_without_user) do
    {
      'event' =>
        {
          'name' => 'evento_testing',
          'address' => 'testing_address',
          'date' => '2020-09-02T00:00:00.000Z',
          'cost' => 200,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'duration' => '2020-10-07T01:00:00.000Z'

        }
    }
  end
  let!(:event_to_update) do
    {
      'event' =>
        {
          'name' => 'evento_update',
          'address' => 'evento_update',
          'date' => '2020-09-02T00:00:00.000Z',
          'cost' => 500,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'duration' => '2020-10-07T01:00:00.000Z'

        }
    }
  end
  describe 'GET /api/v1/admin/events' do
    context 'return all events' do
      it 'return 200 ok' do
        get api_v1_admin_events_path, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']

        expect(events_response[0].except('users')).to include(event.as_json.except('updated_at', 'created_at'))
        expect(events_response[0]['users'][0]['id']).to eq(invitation.as_json['user_id'])
      end
    end
  end
  describe 'GET /api/v1/admin/events/id' do
    context 'event with id' do
      it 'return the event with the respected id' do
        get api_v1_admin_event_path(event.id), headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('users')).to include(event.as_json.except('updated_at', 'created_at'))
        expect(events_response['users'][0]['id']).to eq(invitation.as_json['user_id'])
      end
      it 'return not_found' do
        highest_id = Event.last.id + 1
        get api_v1_admin_event_path(highest_id), headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
  describe 'POST /api/v1/admin/events/' do
    context 'create event with user' do
      it 'return the event created' do
        post api_v1_admin_events_path, params: event_to_create_with_user, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('invitation')).to include(event_to_create_with_user['event'])
      end
    end
    context 'create event without user' do
      it 'return error' do
        post api_v1_admin_events_path, params: event_to_create_without_user, headers: auth_headers
        expect(response).to have_http_status(500)
      end
    end
  end
  describe 'PUT /api/v1/admin/events/:id' do
    context 'update the event' do
      it 'return the event with the respected id' do
        put api_v1_admin_event_path(event.id), params: event_to_update, headers: auth_headers
        expect(response).to have_http_status(200)
        event_response = Oj.load(response.body)['event']
        expect(event_response['id']).to eq(event.id)
      end
      it 'return not_found' do
        highest_id = Event.last.id + 1
        put api_v1_admin_event_path(highest_id), params: event_to_update, headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
