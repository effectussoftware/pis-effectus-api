# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the events' do
        create(:invitation, confirmation: true, user_id: user.id, event: create(
          :event, start_time: Time.zone.now + 1.day
        ))
        invitation = create(:invitation, confirmation: false, user_id: user.id, event: create(
          :event, start_time: Time.zone.now + 1.day
        ))
        Timecop.freeze(Time.zone.now - 1.day) do
          create(:invitation, confirmation: true, user_id: user.id, event: create(:event, start_time: Time.zone.now))
          create(:invitation, confirmation: false, user_id: user.id, event: create(:event, start_time: Time.zone.now))
        end

        get '/api/v1/priority_feed', headers: auth_headers
        expect(response).to have_http_status 200

        feed = Oj.load(response.body)['feed']
        feed_map = feed.as_json

        response_expected = [invitation.event]

        response_expected_map = response_expected.map do |item|
          class_type = item.class.to_s
          item = item.as_json

          invitation = Invitation.find_by(event_id: item['id'], user_id: user.id)
          item['attend'] = invitation.attend
          item['confirmation'] = invitation.confirmation
          item['changed_last_seen'] = invitation.new_updates_since_last_seen?

          {
            id: item['id'],
            text: item['text'],
            title: item['name'],
            type: class_type,
            image: item['image'],
            updated_at: item['updated_event_at'],
            address: item['address'],
            attend: item['attend'],
            end_time: item['end_time'],
            changed_last_seen: item['changed_last_seen'],
            start_time: item['start_time'],
            confirmation: item['confirmation'],
            cancelled: item['cancelled']
          }.as_json
        end
        expect(feed_map).to eq(response_expected_map)
      end
    end

    context 'with no authorization' do
      it 'returns 401' do
        get '/api/v1/feed'
        expect(response).to have_http_status 401
      end
    end
  end
end
