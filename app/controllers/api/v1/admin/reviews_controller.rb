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
          @review = Review.create!(create_review_params.merge(reviewer_id: current_user.id))
        end

        def show
          @review = Review.find(params[:id])
        end

        def update
          @review = Review.find(params[:id])
          @review.update!(update_review_params)
        end

        private

        def update_review_params
          params.require(:review)
                .permit(:title, :comments,
                        user_action_items_attributes: %i[id description completed],
                        reviewer_action_items_attributes: %i[id description completed])
        end

        def create_review_params
          params.require(:review)
                .permit(:title, :comments, :user_id,
                        user_action_items_attributes: %i[id description completed],
                        reviewer_action_items_attributes: %i[id description completed])
        end
      end
    end
  end
end
