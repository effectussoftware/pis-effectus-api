# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:event) { create(:event) }

  let!(:event_to_update) { create(:event) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:event_to_create_with_user) do
    {
      'event' =>
        {
          'name' => 'evento_testing',
          'address' => 'testing_address333',
          'cost' => 200,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'end_time' => '2020-10-07T15:28:06.419Z',
          'cancelled' => false
        },
      'user_ids' => [user.id.to_i]
    }
  end

  let!(:event_to_create_without_user) do
    {
      'event' =>
        {
          'name' => 'evento_testing',
          'address' => 'testing_address',
          'cost' => 200,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'end_time' => '2020-10-07T15:28:06.419Z',
          'cancelled' => false
        }
    }
  end

  let!(:event_data_update) do
    {
      'event' =>
        {
          'name' => 'evento_update',
          'address' => 'evento_update',
          'cost' => 500,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'end_time' => '2020-10-07T15:28:06.419Z',
          'cancelled' => false
        },
      'user_ids' => [user.id]
    }
  end

  describe 'GET /api/v1/admin/events' do
    context 'returns the two pre-existing events' do
      it 'returns 200 ok with a list of events' do
        get api_v1_admin_events_path, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']
        expect(events_response[0].except('users')).to include(event.as_json.except('updated_at', 'created_at'))
        expect(events_response[0]['users'][0]['id']).to eq(invitation.as_json['user_id'])
        expect(events_response[1].except('users')).to include event_to_update.as_json.except('updated_at', 'created_at')
      end
    end
  end

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

  describe 'POST /api/v1/admin/events/' do
    context 'create event with user' do
      it 'returns the event created' do
        post api_v1_admin_events_path, params: event_to_create_with_user, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('invitation')).to include(event_to_create_with_user['event'])
      end
    end

    context 'create event without user' do
      it 'returns error' do
        post api_v1_admin_events_path, params: event_to_create_without_user, headers: auth_headers
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'PUT /api/v1/admin/events/:id' do
    context 'update the event' do
      it 'returns the event updated with the corresponding id' do
        put api_v1_admin_event_path(event_to_update.id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(200)
        event_response = Oj.load(response.body)['event']
        expect(event_response.except('id', 'updated_event_at', 'users')).to include(event_data_update['event'])
        expect(event_response['users'].map { |json| json['id'] }).to eq(event_data_update['user_ids'])
        expect(event_response['id']).to eq(event_to_update.id)
      end

      it 'returns not_found' do
        highest_id = Event.last.id + 1
        put api_v1_admin_event_path(highest_id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
