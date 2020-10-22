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
          @review.destroy!
        end

        def create
          ActiveRecord::Base.transaction do
            # With nested attributes automatically create the review_action_items
            @review = Review.create!(review_params.merge(reviewer_id: current_user.id))
          end
          render :show
        end

        def show
          @review = Review.find(params[:id])
        end

        def update
          @review = Review.find(params[:user_id])
          @review.update!(update_params)
        end

        private

        def update_params
          params.require(:review).permit(:completed, :review_action_item_attributes)
        end

        def create_review_action_item(item)
          item.permit(:description, :type, :completed)
        end

        def review_params
          params.require(:review).permit(:description, :review_action_item_attributes, :user_id)
        end
      end
    end
  end
end
