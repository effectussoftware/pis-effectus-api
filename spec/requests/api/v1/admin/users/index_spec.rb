# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  # Cuando uso create estoy llamando a Factory BOT
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:inactive_user) { create(:user, is_active: false) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'GET /api/v1/admin/users' do
    context 'with authorization' do
      it 'gets all users in page 1' do
        get api_v1_admin_users_path, headers: auth_headers
        expect(response).to have_http_status(200)
        response_body = Oj.load(response.body)

        response_expected_count = [20, User.count].min  # para tener en cuenta el paginado
        expect(response_body['users'].size).to eq(response_expected_count)
      end

      it 'gets only active users' do
        get api_v1_admin_users_path, headers: auth_headers, params: { 'is_active': true }
        expect(response).to have_http_status(200)
        users_response = Oj.load(response.body)['users']

        expect(users_response.size).to eq([20, User.where(is_active: true).count].min)

        users_response.each do |user|
          expect(user['is_active']).to be true
        end
      end

      it 'gets only inactive users' do
        get api_v1_admin_users_path, headers: auth_headers, params: { 'is_active': false }
        expect(response).to have_http_status(200)
        users_response = Oj.load(response.body)['users']

        expect(users_response.size).to eq([20, User.where(is_active: false).count].min)

        users_response.each do |user|
          expect(user['is_active']).to be false
        end
      end
    end

    context 'with no authorization' do
      it 'return unauthorized' do
        get api_v1_admin_users_path
        expect(response).to have_http_status(401)
      end
    end
  end
end
