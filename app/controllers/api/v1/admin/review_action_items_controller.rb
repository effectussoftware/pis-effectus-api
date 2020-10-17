# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReviewsController < Api::V1::Admin::AdminApiController
        def index
          @reviews = Review.all
        end

        def destroy
          @review = Review.find(params[:id])
          @review.destroy
        end

        def create
          @review = Review.create!(review_params)
        end

        def show
          @review = Review.find(params[:id])
        end

        def update
          @review = Review.find(params[:id])
          @review.update!(update_params)
        end

        private

        def update_params
          params.require(:review).permit(:output)
        end

        def review_params
          params.require(:review).permit(:output, :user, :reviewer)
        end
      end
    end
  end
end
