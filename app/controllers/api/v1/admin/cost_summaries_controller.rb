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
          @costs = @events.group("to_char(events.start_time, '#{date_format}')").sum('cost')
        end

        private

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
