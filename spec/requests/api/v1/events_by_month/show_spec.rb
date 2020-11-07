# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event by month index endpoint', type: :request do
  let!(:user) { create(:user) }
  let!(:user_not_invited) { create(:user) }

  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:auth_headers_user_not_invited) { user_not_invited.create_new_auth_token }

  let!(:invitation) { create(:invitation, user: user, event: event) }

  let!(:event) { create(:event, start_time: Time.zone.now + 60 * 60, end_time: Time.zone.now + 60 * 60 * 2) }
  let!(:invitation) { create(:invitation, user: user, event: event) }

  describe 'GET /api/v1/events_by_month/:date' do
    context 'with authentication' do
      it 'returns the events for current month where current user invited' do
        get "/api/v1/events_by_month/#{event.start_time.strftime('%Y-%m-%d')}", headers: auth_headers_user
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)
        # Get date from created event
        date = event.start_time.strftime('%Y-%m-%d')
        # Response must have this key
        expect(events_response).to include(date)
      end
    end

    context 'GET /api/v1/events_by_month/:date with the current user not invited' do
      it 'returns empty object' do
        get "/api/v1/events_by_month/#{event.start_time.strftime('%Y-%m-%d')}", headers: auth_headers_user_not_invited
        expect(response).to have_http_status(200)
        events_response = Oj.load(response.body)
        expect(events_response).to be(nil)
      end
    end
  end
end
