# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  # authorization
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }

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
        expect(response).to have_http_status 403
        created_communication = Communication.first
        expect(created_communication).to eq nil
      end

      it 'sets published to false if nothing is sent' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele' } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq 'Lele'
        expect(created_communication.published).to eq false
      end

      it 'attaches a file to a communication on creation' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'image': open_file_encoded('photo.jpg') } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq 'Lele'
        expect(created_communication.published).to eq false
        expect(created_communication.image.attached?).to eq true
      end

      it 'fails if no title is sent' do
        data = { 'communication': { 'text': 'Lele', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 403
      end

      it 'Sends a notification to all users' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'published': true } }
        expect_any_instance_of(Communication).to receive(:send_notification)
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        expect(response).to have_http_status 200
      end

      it 'creates a communication with the field dummy false' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele', 'dummy': true, 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq 'Lele'
        expect(created_communication.dummy).to eq false
        expect(created_communication.published).to eq true
      end

      it 'creates a recurrent communication' do
        data = { 'communication': { 'title': 'Lala', 'text': 'Lele',
                                    'recurrent_on': '2020-10-28T19:18:36.662Z', 'published': true } }
        post '/api/v1/admin/communications', headers: auth_headers, params: data
        created_communication = Communication.first
        expect(created_communication.title).to eq 'Lala'
        expect(created_communication.text).to eq 'Lele'
        expect(created_communication.recurrent_on).to eq '2020-10-28T19:18:36.662Z'
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
