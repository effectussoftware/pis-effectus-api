# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReviewsController < Api::V1::Admin::AdminApiController
        def index
          @reviews = if params[:user_id]
                       reviews.where(user_id: params[:user_id])
                     else
                       reviews
                     end
          @reviews = sort_reviews if params[:sort]
          @pagy, @reviews = pagy(@reviews, items: params[:per_page])
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
                        user_action_items_attributes: %i[id description completed _destroy],
                        reviewer_action_items_attributes: %i[id description completed _destroy])
        end

        def create_review_params
          params.require(:review)
                .permit(:title, :comments, :user_id,
                        user_action_items_attributes: %i[id description completed],
                        reviewer_action_items_attributes: %i[id description completed])
        end

        def sort_reviews
          sort = Oj.load(params[:sort])
          order_sort = if sort[1]
                         "#{sort[0]} #{sort[1]}"
                       else
                         sort[0]
                       end
          @reviews.reorder(order_sort)
        end

        def reviews
          Review.order(id: :desc)
        end
      end
    end
  end
end
