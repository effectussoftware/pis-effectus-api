# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications index', type: :request do
  let!(:admin) { create(:admin) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:communications) { create_list(:communication, 40) }

  describe 'GET api/v1/admin/communications' do
    context 'with authorization' do
      it 'returns the first 20 communications' do
        get '/api/v1/admin/communications', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        expect(response_body['communications']).to eq(communications[0..19]
        .as_json(
          only: %i[id title text published recurrent_on created_at updated_at]
        ))
      end

      it 'returns the second page of communications' do
        get '/api/v1/admin/communications?page=2', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        expect(response_body['communications']).to eq(communications[20..39]
        .as_json(
          only: %i[id title text published recurrent_on created_at updated_at]
        ))
      end

      it 'returns the first page with ten communications' do
        get '/api/v1/admin/communications?page=1&per_page=10', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        communications_expected = communications[0..9]
        expect(response_body['communications']).to eq(communications_expected
        .as_json(
          only: %i[id title text published recurrent_on created_at updated_at]
        ))
      end

      it 'returns all communications published' do
        get '/api/v1/admin/communications?published=true', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        communications_published = communications.select(&:published)
        expect(response_body['communications']).to eq(communications_published[0..19]
        .as_json(
          only: %i[id title text published recurrent_on created_at updated_at]
        ))
      end

      it 'returns all communications order by created_at' do
        get '/api/v1/admin/communications?sort=["created_at","DESC"]', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        communications_expected = communications.sort_by(&:created_at).reverse
        expect(response_body['communications']).to eq(communications_expected[0..19]
        .as_json(
          only: %i[id title text published recurrent_on created_at updated_at]
        ))
      end
    end
    context 'without authorization' do
      it 'returns unauthorized' do
        get '/api/v1/admin/communications/'
        expect(response).to have_http_status 401
      end
    end
  end
end
