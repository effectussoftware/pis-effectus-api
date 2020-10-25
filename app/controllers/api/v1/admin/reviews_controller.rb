# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReviewsController < Api::V1::Admin::AdminApiController
        before_action only: %i[create update] do
          adjust_for_nested_attributes(%i[user_action_items reviewer_action_items])
        end

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

        def adjust_for_nested_attributes(attrs)
          Array(attrs).each do |param|
            if params[:review][param].present?
              params[:review]["#{param}_attributes"] = params[:review][param]
              params[:review].delete(param)
            end
          end
        end
      end
    end
  end
end
