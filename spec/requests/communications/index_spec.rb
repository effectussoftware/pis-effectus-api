# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  # authorization
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }
  let!(:headers) do
    {
      'uid' => auth_headers[:uid],
      'access-token' => auth_headers['access-token'],
      'client' => auth_headers[:client]
    }

    # database population
  end
  let!(:communication) { create(:communication) }

  describe 'GET api/v1/admin/communications' do
    context 'with authorization' do
      it 'lists all comments' do
        get '/api/v1/admin/communications', headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        expect(response_body['communications'].size).to eq 1
        response_entity = response_body['communications'].first
        expect(response_entity['title']).to eq communication.title
        expect(response_entity['text']).to eq communication.text
        expect(response_entity['published']).to eq communication.published
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        get '/api/v1/admin/communications'
        expect(response).to have_http_status 401
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        get '/api/v1/admin/communications', headers: user_auth_headers
        expect(response).to have_http_status 401
      end
    end
  end
end
