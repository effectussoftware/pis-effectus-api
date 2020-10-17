# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feeds', type: :request do
  # authorization
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }

  let!(:communication) { create_list(:communication, 200) }

  describe 'GET api/v1/feed' do
    context 'with authorization' do
      it 'lists the events' do
        get '/api/v1/feed', headers: auth_headers
        expect(response).to have_http_status 200
      end
    end
  end
end
