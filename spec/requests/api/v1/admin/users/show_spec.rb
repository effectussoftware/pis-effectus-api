# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }

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
end
