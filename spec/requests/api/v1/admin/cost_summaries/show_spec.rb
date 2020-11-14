# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event show endpoint', type: :request do
  let!(:admin) { create(:admin) }
  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:events) { create_list(:event, 10) }
  let!(:events_next_year) do
    create_list(:event, 10, start_time: Time.zone.now + 1.year, end_time: Time.zone.now + 1.year + rand(1..3).hour)
  end

  describe 'GET /api/v1/admin/cost_summary' do
    context 'with authorization' do
      it 'returns costs by year' do
        get api_v1_admin_cost_summary_path, headers: auth_headers
        expect(response).to have_http_status(200)

        expected_costs = Event.group("to_char(events.start_time, 'YYYY')").sum('cost')

        summary_response = Oj.load(response.body)['cost_summary']
        summary_response.each do |summary|
          year = summary['date']
          cost = summary['cost']

          expect(cost).to eq expected_costs[year].to_s
        end
      end

      it 'returns costs by month' do
        year = Time.zone.now.strftime('%Y')
        get api_v1_admin_cost_summary_path, headers: auth_headers, params: { 'year': year }
        expect(response).to have_http_status(200)

        summary_response = Oj.load(response.body)['cost_summary']
        expected_costs = Event.on_year(Time.zone.strptime(year, '%Y'))
                              .group("to_char(events.start_time, 'YYYYMM')")
                              .sum('cost')

        summary_response.each do |summary|
          month = summary['date']
          cost = summary['cost']
          expect(cost).to eq expected_costs[month].to_s
        end
      end
    end
  end
end
