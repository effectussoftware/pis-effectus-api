# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications show', type: :request do
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:auth_headers_user) { user.create_new_auth_token }
  let!(:communication) { create(:communication) }

  describe 'GET api/v1/admin/communications/<id>' do
    context 'with authentication' do
      context 'with authorization' do
        it 'shows the communication' do
          get "/api/v1/admin/communications/#{communication.id}", headers: auth_headers
          expect(response).to have_http_status 200
          response_body = Oj.load(response.body)
          expect(response_body['communication']).to eq(communication.as_json)
        end

        it 'shows 404 if it does not exist' do
          get "/api/v1/admin/communications/#{communication.id + 1}", headers: auth_headers
          expect(response).to have_http_status 404
        end
      end

      context 'without authorization' do
        it 'returns unauthorized' do
          get "/api/v1/admin/communications/#{communication.id}", headers: auth_headers_user
          expect(response).to have_http_status 401
        end

        it 'returns unauthorized if it does not exist' do
          get "/api/v1/admin/communications/#{communication.id + 1}", headers: auth_headers_user
          expect(response).to have_http_status 401
        end
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get "/api/v1/admin/communications/#{communication.id}"
        expect(response).to have_http_status 401
      end

      it 'returns unauthorized if it does not exist' do
        get "/api/v1/admin/communications/#{communication.id + 1}"
        expect(response).to have_http_status 401
      end
    end
  end
end
