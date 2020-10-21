# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  let!(:communications_not_reccurrent) { create_list(:communication, 2, published: true) }
  let!(:communications_recurrent) { create_list(:communication_recurrent, 2) }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the events' do
        get '/api/v1/feed', headers: auth_headers

        communications_recurrent.each { |iter| iter[:updated_at] = Time.zone.parse(iter[:recurrent_on].to_s) }
        response_expected = communications_not_reccurrent + communications_recurrent
        response_expected = response_expected.sort_by(&:updated_at)
                                             .reverse[0..9].as_json(only: %i[id text title updated_at])

        feed = Oj.load(response.body)['feed']
        expect(response).to have_http_status 200
        expect(feed).to include(response_expected)
      end
    end
  end
end
