# frozen_string_literal: true

module Api
  module V1
    module Admin
      class QuestionsController < Api::V1::Admin::AdminApiController
        def index
          survey = get_survey(params[:survey_id])
          if @questions == nil 
            @questions = Question.all
          else
            @questions = survey.questions
          end
          # @questions = sort_questions if params[:sort]
          @pagy, @questions = pagy(@questions, items: params[:per_page])
        end
        def create
          question_type = get_type(params[:question][:question_type])
          survey = get_survey(params[:question][:survey_id])
          @question = Question.new(type: question_type,survey_id: survey.id,name: question_params[:name],max_range: question_params[:max_range],min_range: question_params[:min_range],options: question_params[:question_options])
          @question.save
        end
        def destroy
          @question = Question.find(params[:id])
          @question.destroy!
        end
        def show
          @question = Question.find(params[:id])
        end

        def update
          @question = Question.find(params[:id])
          ActiveRecord::Base.transaction do
            @question.update!(question_params)
          end
        end
        private

        def sort_questions
          sort = Oj.load(params[:sort])
          order_sort = sort.join(' ')
          @questions.order(order_sort)
        end
        def question_params # rubocop:disable Metrics/MethodLength
          params.require(:question).permit(
              :name,
              :survey_id,
              :question_type,
              :max_range,
              :min_range,
              :question_options => []
          ) 
        end   
        def get_type(question_type)
            "Question::#{question_type.camelize}"
        end 
        def get_survey(survey_id)
          Survey.find_by(id: survey_id)
        end    
      end
    end
  end
end
