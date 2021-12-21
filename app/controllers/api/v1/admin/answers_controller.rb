# frozen_string_literal: true

module Api
  module V1
    module Admin
      class AnswersController < Api::V1::Admin::AdminApiController
        before_action :set_answer, only: %i[show update destroy]

        def index
          retrieve_answers
          @pagy, @answers = pagy(@answers, items: params[:per_page])
        end

        def create
          question = Question.find(params[:answer][:question_id])
          @answer = Answer.create!(value: answer_params[:value], question_id: question.id, user_id: current_user.id)
        end

        def show; end

        def update
          ActiveRecord::Base.transaction do
            @answer.update!(answer_params)
          end
        end

        def destroy
          @answer.destroy!
        end

        private

        def retrieve_answers
          @answers = Answer.all
          if params[:question_id].present?
            question = Question.find(params[:question_id])
            @answers = question.answers
          end
          return unless params[:user_id].present?

          user = User.find(params[:user_id])
          @answers = user.answers
        end

        def set_answer
          @answer = Answer.find(params[:id])
        end

        def answer_params
          params.require(:answer).permit(
            :value,
            :question_id
          )
        end
      end
    end
  end
end
