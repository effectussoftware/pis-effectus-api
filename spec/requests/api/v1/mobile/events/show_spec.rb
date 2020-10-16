# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event  show endpoint', type: :request do
  let!(:user) { create(:user) }
  let!(:user_not_invited) { create(:user) }


  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:auth_headers_user_not_invited) { user_not_invited.create_new_auth_token }


  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:event) { create(:event) }
  let!(:invitation) { create(:invitation, user: user, event: event) }

  describe 'get event for mobile endpointn with id ' do
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
        get api_v1_event_path(event.id), headers: auth_headers_user_not_invited
        expect(response).to have_http_status(404)
      end
    end
  end

end
