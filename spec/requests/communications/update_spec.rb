# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  # authorization
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }

  let!(:communication) { create(:communication, published: false) }
  let!(:communication_published) { create(:communication, published: true) }

  describe 'PUT api/v1/admin/communication/:id' do
    context 'with authorization' do
      it 'updates a communication title' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        bd_communication = Communication.first
        expect(bd_communication.title).to eq 'Lala'
      end

      it 'updates a communication text' do
        data = { 'communication': { 'text': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        bd_communication = Communication.first
        expect(bd_communication.text).to eq 'Lala'
      end

      it 'updates a communication published' do
        data = { 'communication': { 'published': false } }
        put "/api/v1/admin/communications/#{communication_published.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 400
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
