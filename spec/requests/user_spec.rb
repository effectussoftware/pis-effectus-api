# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  # Cuando uso create estoy llamando a Factory BOT
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:inactive_user) { create(:user, is_active: false) }

  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:headers) do
    {
      'uid' => auth_headers[:uid],
      'access-token' => auth_headers['access-token'],
      'client' => auth_headers[:client]
    }
  end
  let!(:update_params) do
    {
      'user' =>
            {
              'is_active' => true,
              'is_admin' => true
            }
    }
  end

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
    end

    context 'with no authorization' do
      it 'return unauthorized' do
        get api_v1_admin_users_path
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/admin/users/:id' do
    context 'return the user with id :id' do
      context 'with authorization' do
        it 'get user by id' do
          get "/api/v1/admin/users/#{user.id}", headers: auth_headers
          expect(response).to have_http_status(200)
          response_user = Oj.load(response.body)
          expect(response_user['user']['id']).to eq(user['id'])
        end
        it 'error: no user with id highest_id + 1 ' do
          highest_id = User.last.id
          get "/api/v1/admin/users/#{highest_id + 1}", headers: auth_headers
          expect(response).to have_http_status(404)
        end
      end
      context 'with  no authorization' do
        it 'return unauthorized' do
          get "/api/v1/admin/users/#{user.id}"
          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'PUT /api/v1/admin/users/:id' do
    context 'update the user with id :id' do
      context 'with authorization' do
        it 'update user by id' do
          put "/api/v1/admin/users/#{user.id}", params: update_params, headers: auth_headers
          expect(response).to have_http_status(200)
          response_user = Oj.load(response.body)
          expect(response_user['user']['id']).to eq(user['id'])
          user.reload
          expect(response_user['user']['is_admin']).to eq(true)
          expect(user.is_admin).to eq(true)
        end
        it 'error: no user with id highest id + 1 ' do
          highest_id = User.last.id
          put "/api/v1/admin/users/#{highest_id + 1}", params: update_params.to_json, headers: auth_headers
          expect(response).to have_http_status(404)
        end
      end

      context 'with  no authorization' do
        it 'return unauthorized' do
          put "/api/v1/admin/users/#{user.id}"
          expect(response).to have_http_status(401)
        end
      end
    end
  end
end
