# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Communications', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:user_auth_headers) { user.create_new_auth_token }
  let!(:communication) { create(:communication, published: false) }
  let!(:communication_published) { create(:communication, published: true) }

  describe 'PUT api/v1/admin/communication/:id' do
    context 'with unpublished communication' do
      let(:communication) { create(:communication, published: false) }

      context 'with authorization' do
        it 'updates a communication title' do
          data = { 'communication': { 'title': 'Lala' } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.title).to eq 'Lala'
        end

        it 'updates a communication text' do
          data = { 'communication': { 'text': 'Lala' } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.text).to eq 'Lala'
        end

        it 'updates a communication published' do
          data = { 'communication': { 'published': true } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.published).to eq true
        end

        it 'attaches a file to a communication on update' do
          data = { 'communication': { 'title': 'Lala', 'image': { 'data': open_file_encoded('photo.jpg') } } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.title).to eq 'Lala'
          expect(bd_communication.image.attached?).to eq true
        end

        it 'deattaches a file to a communication on update' do
          data = { 'communication': { 'title': 'Lala', 'image': { 'data': open_file_encoded('photo.jpg') } } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.title).to eq 'Lala'
          expect(bd_communication.image.attached?).to eq true
          data = { 'communication': { 'image': { '_destroy': true } } }
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
          bd_communication = Communication.first
          expect(bd_communication.image.attached?).to eq false
        end

        it 'Sends a notification to all users' do
          data = { 'communication': { 'published': true } }
          expect_any_instance_of(Communication).to receive(:send_notification)
          put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
          expect(response).to have_http_status 200
        end
      end

      context 'without authorization' do
        it 'returns unauthorized' do
          data = { 'communication': { 'title': 'Lala' } }
          put "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers, params: data
          expect(response).to have_http_status 401
        end
      end
    end

    context 'with published communication' do
      let(:communication) { create(:communication, published: true) }
      it "can't be updated" do
        data = { 'communication': { 'title': 'Lala' } }
        communication_title = communication.title
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 403
        expect(Oj.load(response.body)['error']).to match('No es posible actualizar un comunicado publicado')
        communication.reload
        expect(communication.title).to eq(communication_title)
      end
    end

    context 'with recurrent communication' do
      it 'updated succesfully' do
        communication = create(:communication, recurrent_on: Time.zone.now, published: false)
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 200
        communication.reload
        expect(communication.title).to eq 'Lala'
      end

      it 'can not be updated when is published' do
        communication = create(:communication, recurrent_on: Time.zone.now, published: true)
        communication_title = communication.title
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: auth_headers, params: data
        expect(response).to have_http_status 403
        communication.reload
        expect(communication.title).to eq communication_title
      end
    end

    context 'without authorization' do
      let(:communication) { create(:communication) }

      it 'returns unauthorized' do
        data = { 'communication': { 'title': 'Lala' } }
        put "/api/v1/admin/communications/#{communication.id}", headers: user_auth_headers, params: data
        expect(response).to have_http_status 401
      end
    end
  end
end
