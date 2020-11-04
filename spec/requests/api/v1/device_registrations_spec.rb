# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeviceRegistrations', type: :request do
  describe '#create' do
    context 'with correct params' do
      it 'registers a new push_notification_token for the user within the corresponding client' do
        user = create(:user, is_active: true)
        auth_headers = user.create_new_auth_token
        push_notification_token = 'sometoken111'
        post api_v1_device_registrations_path,
             headers: auth_headers,
             params: { device: { token: push_notification_token } }
        expect(response).to have_http_status(200)
        expect(user.reload.tokens[user.tokens.keys[0]]['push_notification_token']).to eq(push_notification_token)
      end
    end

    context 'with incorrect data' do
      it 'Returns 400 if token is missing' do
        user = create(:user, is_active: true)
        auth_headers = user.create_new_auth_token
        post api_v1_device_registrations_path, headers: auth_headers
        expect(response).to have_http_status(400)
        expect(Oj.load(response.body)['error']).to eq('device token is required')
      end
    end
  end
end
