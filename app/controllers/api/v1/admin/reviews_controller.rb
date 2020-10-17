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
          action_items = params[:review_action_item]

          review_action_items = action_items.map { |item| ReviewActionItem.create!(item) }

          params[:review_action_item] = review_action_items

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
          params.require(:review).permit(:completed, :review_action_item)
        end

        def review_params
          params.require(:review).permit(:review_action_item, :user, :reviewer)
        end
      end
    end
  end
end
