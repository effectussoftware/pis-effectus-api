# frozen_string_literal: true

module Api
  module V1
    class ReviewsController < Api::V1::ApiController
      def index
        @reviews = Review.where(user: current_user.id).order(created_at: :desc)
      end

      def show
        @review = Review.find_by(id: params[:id], user: current_user)
      end
    end
  end
end
