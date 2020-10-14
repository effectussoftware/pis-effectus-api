# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  # authorization
  let!(:admin) { create(:admin) }
  let!(:user) { create(:user) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:headers) do
    {
      'uid' => auth_headers[:uid],
      'access-token' => auth_headers['access-token'],
      'client' => auth_headers[:client]
    }

  # database population
  end
  let!(:communication) { create(:communication) }

  describe 'DELETE api/v1/admin/communication/:id' do
    
    context 'with authorization' do
=begin
      it 'updates a communication' do 
        delete '/api/v1/admin/communication/#{communication.id}' headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response)
        puts response_body
      end
    end
=end    
    context 'without authorization' do
      it 'returns unauthorized' do
        delete '/api/v1/admin/communication/#{:communication.id}'
        expect(response).to have_http_status 401
      end
    end

    context 'without authorization' do
      it 'returns unauthorized' do
        delete '/api/v1/admin/communication/#{:communication.id}'
        expect(response).to have_http_status 401
      end

    end
  end

end
