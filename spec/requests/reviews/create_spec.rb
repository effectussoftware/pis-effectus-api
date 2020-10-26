# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:review) { create(:review) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:user_auth_headers) { user.create_new_auth_token }

  let(:create_params) do
    {
      review: {
        title: 'generic_review_title',
        comments: 'generic_review_comment',
        user_id: user.id,
        reviewer_action_items: [
          { description: 'a', completed: false },
          { description: 'b', completed: true }
        ],
        user_action_items: [
          { description: 'd1', completed: true },
          { description: 'd-', completed: false }
        ]
      }
    }
  end

  let(:erroneous_create_params) do
    {
      review: {
        comments: 'generic_review_comment',
        user_id: user.id,
        reviewer_action_items: [
          { description: 'a', completed: false },
          { description: 'b', completed: true }
        ],
        user_action_items: [
          { description: 'd1', completed: true },
          { description: 'd-', completed: false }
        ]
      }
    }
  end

  describe do
    context 'with authentication' do
      context 'with authorization' do
        it 'should create a review' do
          post api_v1_admin_reviews_path, headers: auth_headers, params: create_params
          expect(response).to have_http_status 200

          created_review_obj = Review.last
          reviewer_action_items = created_review_obj.reviewer_action_items.as_json(only: %i[description completed])
          user_action_items = created_review_obj.user_action_items.as_json(only: %i[description completed])

          created_review = created_review_obj.as_json(only: %i[title comments user_id reviewer_id])
          created_review['reviewer_action_items'] = reviewer_action_items
          created_review['user_action_items'] = user_action_items

          expected_review = create_params[:review].as_json
          expected_review['reviewer_id'] = admin.id

          expect(created_review).to eq(expected_review)
        end

        it 'should not create if missing title' do
          post api_v1_admin_reviews_path, headers: auth_headers, params: erroneous_create_params
          expect(response).to have_http_status 403
        end
      end

      context 'with no authorization' do
        it 'should return 401' do
          post api_v1_admin_reviews_path, headers: user_auth_headers
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'with no authentication' do
      it 'should return 401' do
        post api_v1_admin_reviews_path
        expect(response).to have_http_status(401)
      end
    end
  end
end
