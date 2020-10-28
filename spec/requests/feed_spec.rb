# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  let!(:communications_not_reccurrent) { create_list(:communication, 5, published: true) }
  let!(:reviews) { create_list(:review_with_action_items, 5, user_id: user.id) }
  let!(:communication_recurrent_dummy) { create_list(:communication_recurrent_dummy, 5) }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the communications and reviews' do
        get '/api/v1/feed', headers: auth_headers
        expect(response).to have_http_status 200

        feed = Oj.load(response.body)['feed']
        feed_map = feed.map do |f|
          {
            id: f['id'],
            text: f['text'],
            title: f['title'],
            updated_at: f['updated_at']
          }
        end
        
        response_expected = communications_not_reccurrent + communication_recurrent_dummy + reviews
        response_expected = response_expected.sort_by(&:updated_at)
                                             .reverse[0..9].as_json(only: %i[id text title comments updated_at])

        response_expected_map = response_expected.map do |item|
          {
            id: item['id'],
            text: item['text'] || item['comments'],
            title: item['title'],
            updated_at: item['updated_at']
          }
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
