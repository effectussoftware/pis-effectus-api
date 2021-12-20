# frozen_string_literal: true
module Api
  module V1
    module Admin
      class AnswersController < Api::V1::Admin::AdminApiController
        def index
          @answers = Answer.all
          if params[:question_id].present?
            question = Question.find_by(id: params[:question_id])
            @answers = question.answers
          end
          if params[:user_id].present? 
            user = User.find_by(id: params[:user_id])
            @answers = user.answers
          end
          @pagy, @answers = pagy(@answers, items: params[:per_page])
        end
        def create
          question = Question.find_by(id: params[:answer][:question_id])
          @answer = Answer.create!(value: answer_params[:value],question_id: question.id,user_id: current_user.id)
        end
        def show
          @answer = Answer.find(params[:id])
        end
        def update
          @answer = Answer.find(params[:id])
          ActiveRecord::Base.transaction do
            @answer.update!(answer_params)
          end
        end
        def destroy
          @answer = Answer.find(params[:id])
          @answer.destroy!
        end
        private
        def sort_answers
          sort = Oj.load(params[:sort])
          order_sort = sort.join(' ')
          @answers.order(order_sort)
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
