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

  describe 'GET api/v1/admin/communication/:id' do
    context 'with authorization' do
      it 'shows a communication' do
        get "/api/v1/admin/communications/#{communication.id}", headers: auth_headers
        expect(response).to have_http_status 200
        response_entity = Oj.load(response.body)
        expect(response_entity['title']).to eq communication.title
        expect(response_entity['text']).to eq communication.text
        expect(response_entity['published']).to eq communication.published
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        get "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers
        expect(response).to have_http_status 401
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get "/api/v1/admin/communications/#{communication.id}"
        expect(response).to have_http_status 401
      end
    end
  end
end
