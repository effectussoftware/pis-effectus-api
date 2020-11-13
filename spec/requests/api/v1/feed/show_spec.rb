# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  let!(:communications_not_reccurrent) { create_list(:communication, 5, published: true) }
  let!(:reviews) { create_list(:review_with_action_items, 5, user_id: user.id) }
  let!(:communication_recurrent_dummy) { create_list(:communication_recurrent_dummy, 5) }
  let!(:events) { create_list(:event, 5) }
  let!(:invitations) { (1..3).map { create(:invitation, user_id: user.id, event: create(:event)) } }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the communications, reviews and events' do
        get '/api/v1/feed', headers: auth_headers
        expect(response).to have_http_status 200

        feed = Oj.load(response.body)['feed']
        feed_map = feed.map { |f| f.as_json(only: %w[id text title updated_at]) }

        user_events = invitations.map(&:event)
        response_expected = communications_not_reccurrent + communication_recurrent_dummy + reviews + user_events
        response_expected = response_expected.sort_by(&:updated_at).reverse[0..9]
                                             .as_json(only: %w[id text title name comments updated_at event_updated_at])

        response_expected_map = response_expected.map do |item|
          {
            id: item['id'],
            text: item['text'] || item['comments'],
            title: item['title'] || item['name'],
            updated_at: item['event_updated_at'] || item['updated_at']
          }.as_json
        end
        expect(feed_map).to eq(response_expected_map)
      end

      it 'shows only the current user reviews' do
        get '/api/v1/feed', headers: auth_headers
        expect(response).to have_http_status 200

        feed = Oj.load(response.body)['feed']

        feed.each do |f|
          next if f['type'] != 'review'

          review_user = Review.find(f['id']).user
          expect(review_user.id).to eq(user.id)
        end
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
