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
          ActiveRecord::Base.transaction do
            @review = Review.create!(review_params.merge(reviewer_id: current_user.id))
            review_action_items = params[:review_action_items].map do |item|
              ReviewActionItem.create!(
                create_review_action_item(item).merge(review_id: @review.id)
              )
            end
            @review.review_action_item = review_action_items
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
          params.require(:review).permit(:completed, :review_action_item)
        end

        def create_review_action_item(item)
          item.permit(:description, :type, :completed)
        end

        def review_params
          params.require(:review).permit(:description, :review_action_item, :user_id)
        end
      end
    end
  end
end
