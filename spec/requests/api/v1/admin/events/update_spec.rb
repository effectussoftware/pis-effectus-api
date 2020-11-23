# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event update endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:event) { create(:event) }

  let!(:event_data_update) do
    {
      'event' =>
        {
          'name' => 'evento_update',
          'address' => 'testing_address333',
          'cost' => '200.55',
          'start_time' => (Time.zone.now + 2.hour),
          'end_time' => (Time.zone.now + 5.hour),
          'cancelled' => false,
          'invitations_attributes' => [
            {
              'user_id' => user.id,
              'attend' => false
            }
          ]
        }
    }
  end

  describe 'PUT /api/v1/admin/events/:id' do
    context 'update the event' do
      it 'returns the event updated with the corresponding id' do
        put api_v1_admin_event_path(event.id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(200)
        event_response = Oj.load(response.body)['event']

        expect(event_response.except('invitations', 'id', 'start_time', 'end_time'))
          .to include(event_data_update['event']
          .as_json
          .except('invitations_attributes', 'start_time', 'end_time'))

        invitations = event_response['users'].map do |iter|
          {
            'user_id' => iter['id'],
            'attend' => iter['attend']
          }
        end
        expect(invitations).to include(event_data_update['event']['invitations_attributes'][0])
      end

      it 'returns not_found' do
        highest_id = Event.last.id + 1
        put api_v1_admin_event_path(highest_id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(404)
      end

      it 'updates updated_event_at when public fields are changed' do
        event = nil
        Timecop.freeze(Date.today - 1.hour) do
          event = create(:event, start_time: Time.zone.now + 1.hour, end_time: Time.zone.now + 2.hour)
        end
        Timecop.freeze(Date.today) do
          params_update = { event: { end_time: Time.zone.now + 3.hour } }
          put api_v1_admin_event_path(event.id), params: params_update, headers: auth_headers
          event_response = Oj.load(response.body)['event']
          expect(Time.zone.parse(event_response['updated_event_at'])).to eq(Time.zone.now)
        end
      end

      it 'does not update updated_event_at when only private fields are changed' do
        event = nil
        time = nil
        Timecop.freeze(Date.today - 1.hour) do
          time = Time.zone.now
          event = create(:event, cost: 200, start_time: Time.zone.now + 1.hour, end_time: Time.zone.now + 2.hour)
        end
        Timecop.freeze(Date.today) do
          params_update = { event: { cost: 300 } }
          put api_v1_admin_event_path(event.id), params: params_update, headers: auth_headers
          event_response = Oj.load(response.body)['event']
          expect(Time.zone.parse(event_response['updated_event_at'])).to eq(time)
        end
      end

      it 'does not update a cancelled event' do
        cancelled_event = create(:event, cancelled: true)
        put api_v1_admin_event_path(cancelled_event.id), params: event_data_update, headers: auth_headers
        expect(response).to have_http_status(403)
        expect(Oj.load(response.body)['error']).to match('No es posible actualizar un evento cancelado')
        cancelled_event.reload
        expect(cancelled_event.cancelled).to eq(true)
      end

      it 'does not update a published event to unpublished' do
        published_event = create(:event, published: true)
        params_update = { 'event' => { 'published' => false } }
        put api_v1_admin_event_path(published_event.id), params: params_update, headers: auth_headers
        expect(response).to have_http_status(403)
        expect(Oj.load(response.body)['error']).to match('No es posible cambiar el campo publicado del evento')
        published_event.reload
        expect(published_event.published).to eq(true)
      end
    end
  end
end
