# frozen_string_literal: true

module Api
  module V1
    class AnswersController < Api::V1::ApiController
      def index
        answers
        @answers
      end

      def create
        create_answers(params[:answers])
      end

      def show; end

      def update
        answer.update!(answer_params)
      end

      def destroy
        answer.destroy!
      end

      private

      def create_answers(answers)
        answers.each do |answer|
          question = Question.find(answer[:question_id])
          @answer = Answer.create!(value: answer[:value], question_id: question.id, user_id: current_user.id)
        end
      end

      def answers
        if params[:question_id].present?
          question = Question.find(params[:question_id])
          @answers = question.answers
        elsif params[:user_id].present?
          user = User.find(params[:user_id])
          @answers = user.answers
        else
          @answers = Answer.all
        end
      end

      def options_question(question)
        question.type == 'Question::MultipleChoice' || question.type == 'Question::MultiSelect'
      end

      def answer
        @answer ||= Answer.find(params[:id])
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
