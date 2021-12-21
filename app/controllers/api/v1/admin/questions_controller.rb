# frozen_string_literal: true

module Api
  module V1
    module Admin
      class QuestionsController < Api::V1::Admin::AdminApiController
        before_action :retrieve_question, only: %i[show update destroy]
        before_action :retrieve_question_params, only: [:create]

        def index
          survey = get_survey(params[:survey_id])
          @questions = if survey.nil?
                         Question.all
                       else
                         survey.questions
                       end

          @pagy, @questions = pagy(@questions, items: params[:per_page])
        end

        def create
          @question = Question.create!(type: @question_type, survey_id: @survey.id,
                                       name: question_params[:name], max_range: question_params[:max_range],
                                       min_range: question_params[:min_range],
                                       options: question_params[:question_options])
        end

        def destroy
          @question.destroy!
        end

        def show
          @question
        end

        def update
          ActiveRecord::Base.transaction do
            @question.update!(question_params)
          end
        end

        private

        def retrieve_question_params
          @question_type = get_type(params[:question][:question_type])
          @survey = get_survey(params[:question][:survey_id])
        end

        def retrieve_question
          @question = Question.find(params[:id])
        end

        def question_params
          params.require(:question).permit(
            :name,
            :survey_id,
            :question_type,
            :max_range,
            :min_range,
            question_options: []
          )
        end

        def get_type(question_type)
          "Question::#{question_type.camelize}"
        end

        def get_survey(survey_id)
          Survey.find(survey_id)
        end
      end
    end
  end
end
