# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event update endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:event) { create(:event) }

  let!(:event_data_update) do
    {
      'event' =>
        {
          'name' => 'evento_update',
          'address' => 'testing_address333',
          'cost' => 200,
          'start_time' => '2020-10-07T13:28:06.419Z',
          'end_time' => '2020-10-07T15:28:06.419Z',
          'cancelled' => false,
          'invitations_attributes' => [
            {
              'user_id' => user.id,
              'attend' => false
            }
          ]
        }
    }
  end

  describe 'PUT /api/v1/admin/events/:id' do
    context 'update the event' do
      it 'returns the event updated with the corresponding id' do
        put api_v1_admin_event_path(event.id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(200)
        event_response = Oj.load(response.body)['event']

        expect(event_response.except('invitations', 'id')).to include(event_data_update['event']
          .as_json
          .except('invitations_attributes'))
        invitations = event_response['invitations'].map do |iter|
          {
            'user_id' => iter['user_id'],
            'attend' => iter['attend']
          }
        end
        expect(invitations).to include(event_data_update['event']['invitations_attributes'][0])
      end

      it 'returns not_found' do
        highest_id = Event.last.id + 1
        put api_v1_admin_event_path(highest_id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end
  end
end
