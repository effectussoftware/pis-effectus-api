# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
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

  before(:each) do
    allow_any_instance_of(Communication).to receive(:send_notification).and_return(true)
  end

  describe 'POST api/v1/admin/communications' do
    context 'with authorization' do
      it 'creates a communication with all the params set' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq 'Lele'
        expect(created_communication.published).to eq true
      end

      it 'creates a communication when no text is sent' do
        data = { 'communication': { 'title': 'Lala', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.published).to eq true
        expect(created_communication.text).to eq nil
      end

      it 'sets published to false if nothing is sent' do
        data = { 'communication': { 'title': 'Lala' } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq nil
        expect(created_communication.published).to eq false
      end

      it 'fails if no title is sent' do
        data = { 'communication': { 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 403
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

  describe 'DELETE api/v1/admin/communication/:id' do
    let(:communication) { create(:communication) }

    context 'with authorization' do
      it 'updates a communication' do
        delete "/api/v1/admin/communications/#{communication.id}", headers: auth_headers
        expect(response).to have_http_status 204
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        delete "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers
        expect(response).to have_http_status 401
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        delete "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers
        expect(response).to have_http_status 401
      end
    end
  end

  describe 'PUT api/v1/admin/communication/:id' do
    context 'with unpublished communication' do
      let(:communication) { create(:communication, published: false) }

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
          data = { 'communication': { 'published': true } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.published).to eq true
        end

        it 'Sends a notification to all users' do
          data = { 'communication': { 'published': true } }
          expect_any_instance_of(Communication).to receive(:send_notification)
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
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

    context 'with published communication' do
      let(:communication) { create(:communication, published: true) }

      it "can't be updated" do
        data = { 'communication': { 'title': 'Lala' } }
        communication_title = communication.title
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 403
        expect(Oj.load(response.body)['error']).to match("can't update communications once published")
        communication.reload
        expect(communication.title).to eq(communication_title)
      end
    end

    context 'without authorization' do
      let(:communication) { create(:communication) }

      it 'returns unauthorized' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers, params: data
        expect(response).to have_http_status 401
      end
    end
  end
end
