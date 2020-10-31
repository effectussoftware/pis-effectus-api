# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:user_auth_headers) { user.create_new_auth_token }

  describe 'PUT api/v1/admin/users' do
    it 'destroy user tokens if deactivated' do
      data = { 'user': { 'is_active': false } }
      expect(user.tokens).to_not eq({})
      put api_v1_admin_user_path(user), headers: auth_headers, params: data
      expect(response).to have_http_status 200
      user.reload
      expect(user.tokens).to eq({})
    end
  end
end
