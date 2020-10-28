# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:user_auth_headers) { user.create_new_auth_token }

  let!(:communication) { create(:communication) }

  describe 'DELETE api/v1/admin/communication/:id' do
    context 'with authorization' do
      it 'delete a communication' do
        delete "/api/v1/admin/communications/#{communication.id}", headers: auth_headers
        expect(response).to have_http_status 204
      end

      it 'returns not found' do
        delete "/api/v1/admin/communications/#{Communication.last.id + 1}", headers: auth_headers
        expect(response).to have_http_status 404
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
end
