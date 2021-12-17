# frozen_string_literal: true

module Api
    module V1
      module Admin
        class SurveysController < Api::V1::Admin::AdminApiController
          def index
            @surveys = Survey.all
            # @surveys = sort_surveys if params[:sort]
            @pagy, @surveys = pagy(@surveys, items: params[:per_page])
          end
  
          def create
            @survey = Survey.create!(survey_params)
          end
  
          def show
            @survey = Survey.find(params[:id])
          end

          def destroy
            @survey = Survey.find(params[:id])
            @survey.destroy!
          end

          def update
            @survey = Survey.find(params[:id])
            ActiveRecord::Base.transaction do
            @survey.update!(survey_params)
            end
          end
  
          private
  
          def sort_surveys
            sort = Oj.load(params[:sort])
            order_sort = sort.join(' ')
            @surveys.order(order_sort)
          end
  
          def survey_params # rubocop:disable Metrics/MethodLength
            params.require(:survey).permit(
                :name,
                :description,
            )
          end
        end
      end
    end
  end
  