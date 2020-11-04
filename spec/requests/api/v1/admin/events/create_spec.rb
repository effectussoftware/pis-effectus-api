# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event create endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }
  let!(:userTwo) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:event_to_create_with_user) do
    {
      'event' =>
        {
          'name' => 'evento_testing',
          'address' => 'testing_address333',
          'cost' => 200,
          'start_time' => (Time.zone.now + 2.hour),
          'end_time' => (Time.zone.now + 5.hour),
          'cancelled' => false,
          'invitations_attributes' => [
            {
              'user_id' => user.id,
              'attend' => false
            },
            {
              'user_id' => userTwo.id,
              'attend' => false
            }
          ]
        }
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

  describe 'POST /api/v1/admin/events/' do
    context 'create event with user' do
      it 'returns the event created' do
        post api_v1_admin_events_path, params: event_to_create_with_user, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['event']
        expect(events_response.except('invitations', 'id', 'start_time', 'end_time'))
          .to include(event_to_create_with_user['event']
          .as_json
          .except('invitations_attributes', 'start_time', 'end_time'))
        invitations = events_response['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend']
          }
        end
        expect(invitations).to eq((event_to_create_with_user['event']['invitations_attributes']))
      end
    end

    context 'create event without user' do
      it 'returns error' do
        post api_v1_admin_events_path, params: event_to_create_without_user, headers: auth_headers
        expect(response).to have_http_status(403)
      end
    end
  end
end
