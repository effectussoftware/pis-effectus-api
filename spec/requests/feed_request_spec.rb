# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feed', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  let!(:communications_not_reccurrent) { create_list(:communication, 10, published: true) }
  let!(:communications_recurrent) { create_list(:communication_recurrent, 10) }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the communications' do
        get '/api/v1/feed', headers: auth_headers
        communications_recurrent = Communication.recurrent_from_date(Time.zone.now, false)
        communications_recurrent.each { |iter| iter[:updated_at] = Time.zone.parse(iter[:recurrent_on].to_s) }
        response_expected = communications_not_reccurrent + communications_recurrent
        response_expected = response_expected.sort_by(&:updated_at)
                                             .reverse[0..9].as_json(only: %i[id text title])
        feed = Oj.load(response.body)['feed']
        expect(response).to have_http_status 200
        feed_map = feed.map do |f|
          {
            id: f['id'],
            text: f['text'],
            title: f['title']
          }
        end
        response_expected_map = response_expected.map do |item|
          {
            id: item['id'],
            text: item['text'],
            title: item['title']
          }
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
