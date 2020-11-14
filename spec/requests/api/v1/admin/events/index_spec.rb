# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event index endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'GET /api/v1/admin/events' do
    context 'returns the two pre-existing events' do
      let!(:events) { create_list(:event, 2) }
      it 'returns 200 ok with a list of events' do
        get api_v1_admin_events_path, headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']
        events = Event.all
        expect(events_response[0].except('invitations')).to include(
          events[0]
          .as_json
          .except('updated_at', 'created_at')
        )
        expect(events_response[1].except('invitations')).to include(
          events[1]
          .as_json
          .except('updated_at', 'created_at')
        )

        invitations = events_response[0]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[0].invitations.as_json(only: %i[user_id attend confirmation]))
        invitations = events_response[1]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[1].invitations.as_json(only: %i[user_id attend confirmation]))
      end
    end

    context 'returns the second page of  events' do
      let!(:events) { create_list(:event, 22) }
      it 'returns 200 ok with a list of events' do
        get '/api/v1/admin/events?page=1', headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']
        expect(events_response[0].except('invitations')).to include(
          events[0]
          .as_json
          .except('updated_at', 'created_at')
        )
        expect(events_response[1].except('invitations')).to include(
          events[1]
          .as_json
          .except('updated_at', 'created_at')
        )

        invitations = events_response[0]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[0].invitations.as_json(only: %i[user_id attend confirmation]))
        invitations = events_response[1]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[1].invitations.as_json(only: %i[user_id attend confirmation]))
      end
    end

    context 'returns  the two pre-existing order by idevents' do
      let!(:events) { create_list(:event, 2) }
      it 'returns 200 ok with a list of events' do
        get '/api/v1/admin/events?sort=["id","DESC"]', headers: auth_headers
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)['events']

        expect(events_response[1].except('invitations')).to include(
          events[0]
          .as_json
          .except('updated_at', 'created_at')
        )
        expect(events_response[0].except('invitations')).to include(
          events[1]
          .as_json
          .except('updated_at', 'created_at')
        )

        invitations = events_response[1]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[0].invitations.as_json(only: %i[user_id attend confirmation]))
        invitations = events_response[0]['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend'],
            'confirmation' => iter['confirmation']
          }
        end
        expect(invitations).to eq(events[1].invitations.as_json(only: %i[user_id attend confirmation]))
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
