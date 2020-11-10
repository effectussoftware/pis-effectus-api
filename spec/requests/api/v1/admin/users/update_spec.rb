# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }

  let!(:update_params) do
    {
      'user' =>
            {
              'is_active' => true,
              'is_admin' => true
            }
    }
  end

  describe 'PUT api/v1/admin/users' do
    it 'destroy user tokens if deactivated' do
      data = { 'user': { 'is_active': false } }
      expect(user.tokens).to_not eq({})
      put api_v1_admin_user_path(user), headers: auth_headers, params: data
      expect(response).to have_http_status 200
      user.reload
      expect(user.tokens).to eq({})
    end

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
