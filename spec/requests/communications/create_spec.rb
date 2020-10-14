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
  end

  describe 'POST api/v1/admin/communications' do
    context 'with authorization' do
      it 'creates a communication with all the params set' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        entity = response_body['data']
        created_communication = Communication.first
        # The returned object is in the db
        expect(entity['id']).to eq created_communication.id
        expect(entity['title']).to eq created_communication.title
        expect(entity['text']).to eq created_communication.text
        expect(entity['published']).to eq created_communication.published
        # The returned object is what I sent
        sent_communication = data[:communication]
        expect(entity['title']).to eq sent_communication[:title]
        expect(entity['text']).to eq sent_communication[:text]
        expect(entity['published']).to eq sent_communication[:published]
      end

      it 'creates a communication when no text is sent' do
        data = { 'communication': { 'title': 'Lala', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        entity = response_body['data']
        created_communication = Communication.first
        # The returned object is in the db
        expect(entity['id']).to eq created_communication.id
        expect(entity['title']).to eq created_communication.title
        expect(entity['published']).to eq created_communication.published
        expect(created_communication.text).to eq nil
        # The returned object is what I sent
        sent_communication = data[:communication]
        expect(entity['title']).to eq sent_communication[:title]
        expect(entity['published']).to eq sent_communication[:published]
      end

      it 'sets published to false if nothing is sent' do
        data = { 'communication': { 'title': 'Lala' } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        entity = response_body['data']
        created_communication = Communication.first
        # The returned object is in the db
        expect(entity['id']).to eq created_communication.id
        expect(entity['title']).to eq created_communication.title
        expect(created_communication.published).to eq false
        expect(created_communication.text).to eq nil
        # The returned object is what I sent
        sent_communication = data[:communication]
        expect(entity['title']).to eq sent_communication[:title]
      end

      it 'fails if no title is sent' do
        data = { 'communication': { 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 500
        # TODO: ESTO DEBERIA DEVOLVER 400 Y NO ROMPER EL SERVER
      end
    end
    context 'without authorization' do
      it 'returns unauthorized' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: user_auth_headers, params: data
        expect(response).to have_http_status 401
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        post '/api/v1/admin/communications'
        expect(response).to have_http_status 401
      end
    end
  end
end
