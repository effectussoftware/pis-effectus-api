# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CostSummariesController < Api::V1::Admin::AdminApiController
        def show
          @events = Event.all
          @events = filter_events if params[:year]
          date_format = 'YYYY'
          date_format += 'MM' if params[:year]
          @costs_pesos = get_costs('pesos', date_format)
          @costs_dolares = get_costs('dolares', date_format)
        end

        private

        def get_costs(currency, date_format)
          costs = @events.where(currency: currency)
                         .group("to_char(events.start_time, '#{date_format}')")
                         .sum('cost')

          costs.map { |date, cost| { date: date, cost: cost } }
               .sort_by { |x| x[:date] }
        end

        def filter_events
          return unless params[:year]

          raise ActionController::BadRequest unless Time.zone.strptime(params[:year], '%Y')

          date = Time.zone.strptime(params[:year], '%Y')
          @events.on_year(date)
        end
      end
    end
  end
end
