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
          render :show
        end

        def show
          @review = Review.find(params[:id])
        end

        def update
          @review = Review.find(params[:id])
          @review.update!(update_review_params)
          render :show
        end

        private

<<<<<<< HEAD
        def update_review_params
          params.require(:review)
                .permit(:description,
                        review_action_items_attributes: %i[id description completed commitment_owner])
        end

        def create_review_params
          params.require(:review)
                .permit(:description,
                        :user_id,
                        review_action_items_attributes: %i[description completed commitment_owner])
=======
        def update_params
          params.require(:review).permit(:completed, :review_action_item_attributes)
        end

        def create_review_action_item(item)
          item.permit(:description, :type, :completed)
        end

        def review_params
          params.require(:review).permit(:description, :review_action_item_attributes, :user_id)
>>>>>>> Add nested attributes for review
        end
      end
    end
  end
end
