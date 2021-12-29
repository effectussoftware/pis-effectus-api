# frozen_string_literal: true

module Api
  module V1
    module Admin
      class QuestionsController < Api::V1::Admin::AdminApiController
        before_action :question, only: %i[show update destroy]
        before_action :question_info, only: [:create]

        def index
          survey = survey(params[:survey_id])
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
          options_answers(@question.id, @question.options)
        end

        def destroy
          question.destroy!
        end

        def show
          question
        end

        def update
          question.update!(question_params)
        end

        private

        def question_info
          @question_type = type(params[:question][:question_type])
          @survey = survey(params[:question][:survey_id])
        end

        def question
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

        def options_answers(question_id, question_options)
          return if @question.options.nil?

          question_options.each do |option|
            MultipleChoiceAnswer.create!(value: option, question_id: question_id)
          end
        end

        def type(question_type)
          "Question::#{question_type.camelize}"
        end

        def survey(survey_id)
          Survey.find_by(id: survey_id)
        end
      end
    end
  end
end
