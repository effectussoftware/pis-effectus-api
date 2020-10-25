# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications show', type: :request do
  let!(:user) { create(:user) }
  let!(:auth_headers) { user.create_new_auth_token }
  let!(:communication) { create(:communication, published: true) }
  let!(:unpublished_communication) { create(:communication, published: false) }

  describe 'GET api/v1/communications/<id>' do
    context 'with authentication' do
      it 'shows the communication if published' do
        get "/api/v1/communications/#{communication.id}", headers: auth_headers
        expect(response).to have_http_status 200
        response_body = Oj.load(response.body)['communication']
        expect(response_body['id']).to eq(communication.id)
        expect(response_body['title']).to eq(communication.title)
        expect(response_body['text']).to eq(communication.text)
      end
      
      it 'shows 404 if not published' do
        get "/api/v1/communications/#{unpublished_communication.id}", headers: auth_headers
        expect(response).to have_http_status 404
      end
      
      it 'shows 404 if it does not exist' do
        get "/api/v1/communications/#{communication.id + 1}", headers: auth_headers
        expect(response).to have_http_status 404
      end
    end

    context 'without authentication' do
      it 'returns unauthorized' do
        get "/api/v1/communications/#{communication.id}"
        expect(response).to have_http_status 401
      end
      
      it 'returns unauthorized if it does not exist' do
        get "/api/v1/communications/#{communication.id + 1}"
        expect(response).to have_http_status 401
      end
    end
  end
end
