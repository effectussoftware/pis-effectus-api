# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Events Calendar index endpoint', type: :request do
  let!(:user) { create(:user) }
  let!(:user_not_invited) { create(:user) }

  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:auth_headers_user_not_invited) { user_not_invited.create_new_auth_token }

  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:event) { create(:event, start_time: Time.zone.now + 60 * 60, end_time: Time.zone.now + 60 * 60 * 2) }
  let!(:invitation) { create(:invitation, user: user, event: event) }

  describe 'GET /api/v1/events_calendar/:date' do
    context 'with authentication' do
      it 'returns the events for current month where current user invited' do
        get api_v1_events_calendar_path(event.start_time.strftime('%Y-%m')), headers: auth_headers_user
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)

        event_list = Event.on_month(event.start_time, user)
        events = event_list.map { |e| e.as_json(except: %i[cost created_at updated_at]) }

        expect(events_response['events']).to match(events)
      end
    end

    context 'with the current user not invited' do
      it 'returns empty object' do
        get api_v1_events_calendar_path(event.start_time.strftime('%Y-%m-%d')), headers: auth_headers_user_not_invited
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)
        expect(events_response['events']).to match([])
      end
    end
  end
end
