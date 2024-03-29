# frozen_string_literal: true

module Api
  module V1
    module Admin
      class SurveysController < Api::V1::Admin::AdminApiController
        def index
          @surveys = Survey.all
          @pagy, @surveys = pagy(@surveys, items: params[:per_page])
        end

        def create
          @survey = Survey.create!(survey_params)
        end

        def show; end

        def destroy
          survey.destroy!
        end

        def update
          survey.update!(survey_params)
        end

        private

        def survey
          @survey ||= Survey.find(params[:id])
        end

        def survey_params
          params.require(:survey).permit(
            :name,
            :description
          )
        end
      end
    end
  end
end
