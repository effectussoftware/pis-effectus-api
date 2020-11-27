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

        expected_costs_pesos = Event.where(currency: 'pesos')
                                    .group("to_char(events.start_time, 'YYYY')")
                                    .sum('cost')
        expected_costs_dolares = Event.where(currency: 'dolares')
                                      .group("to_char(events.start_time, 'YYYY')")
                                      .sum('cost')

        summary_response_pesos = Oj.load(response.body)['cost_summary']['pesos']
        summary_response_dolares = Oj.load(response.body)['cost_summary']['dolares']

        summary_response_pesos.each do |summary|
          year = summary['date']
          cost = summary['cost']
          expect(cost).to eq expected_costs_pesos[year].to_s
        end

        summary_response_dolares.each do |summary|
          year = summary['date']
          cost = summary['cost']
          expect(cost).to eq expected_costs_dolares[year].to_s
        end
      end

      it 'returns costs by month' do
        year = Time.zone.now.strftime('%Y')
        get api_v1_admin_cost_summary_path, headers: auth_headers, params: { 'year': year }
        expect(response).to have_http_status(200)

        summary_response_pesos = Oj.load(response.body)['cost_summary']['pesos']
        expected_costs_pesos = Event.where(currency: 'pesos').on_year(Time.zone.strptime(year, '%Y'))
                                    .group("to_char(events.start_time, 'YYYYMM')")
                                    .sum('cost')

        summary_response_dolares = Oj.load(response.body)['cost_summary']['dolares']
        expected_costs_dolares = Event.where(currency: 'dolares').on_year(Time.zone.strptime(year, '%Y'))
                                      .group("to_char(events.start_time, 'YYYYMM')")
                                      .sum('cost')

        summary_response_pesos.each do |summary|
          month = summary['date']
          cost = summary['cost']
          expect(cost).to eq expected_costs_pesos[month].to_s
        end
        summary_response_dolares.each do |summary|
          month = summary['date']
          cost = summary['cost']
          expect(cost).to eq expected_costs_dolares[month].to_s
        end
      end
    end
  end
end
