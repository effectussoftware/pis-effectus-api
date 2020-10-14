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

  describe 'PUT api/v1/admin/communication/:id' do
    context 'with authorization' do
      it 'updates a communication title' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        bd_communication = Communication.first
        expect(response_body['data']['title']).to eq bd_communication.title
      end

      it 'updates a communication text' do
        data = { 'communication': { 'text': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        bd_communication = Communication.first
        expect(response_body['data']['text']).to eq bd_communication.text
      end

      it 'updates a communication published' do
        data = { 'communication': { 'published': false } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)
        bd_communication = Communication.first
        expect(response_body['data']['published']).to eq bd_communication.published
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers, params: data
        expect(response).to have_http_status 401
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers, params: data
        expect(response).to have_http_status 401
      end
    end
  end
end
