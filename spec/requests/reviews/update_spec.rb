# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:review) { create(:review, user_id: user.id, reviewer_id: admin.id) }

  let!(:reviewer_action_item) { create(:reviewer_action_item, reviewer_review_id: review.id) }
  let!(:reviewer_action_item2) { create(:reviewer_action_item, reviewer_review_id: review.id) }

  let!(:user_action_item) { create(:user_action_item, user_review_id: review.id) }

  let(:update_params) do
    {
      review: {
        title: 'updated title',
        comments: 'different comment',
        user_id: review.user_id,
        reviewer_id: review.reviewer_id,
        reviewer_action_items_attributes: [
          { id: reviewer_action_item.id, description: 'new description', completed: !reviewer_action_item.completed },
          reviewer_action_item2.as_json(only: %i[id description completed])
        ],
        user_action_items_attributes: review.user_action_items.as_json(only: %i[id description completed])
      }
    }
  end

  let(:update_params_delete_ai) do
    {
      review: {
        title: 'updated title',
        comments: 'different comment',
        user_id: review.user_id,
        reviewer_id: review.reviewer_id,
        reviewer_action_items_attributes: [
          reviewer_action_item.as_json(only: %i[id description completed]),
          { id: reviewer_action_item2.id, _destroy: '1' }
        ],
        user_action_items_attributes: review.user_action_items.as_json(only: %i[id description completed])
      }
    }
  end

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:user_auth_headers) { user.create_new_auth_token }

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'with authentication' do
      context 'with authorization' do
        it 'should update all fields' do
          put api_v1_admin_review_path(review), params: update_params, headers: auth_headers
          expect(response).to have_http_status 200

          review.reload
          reviewer_action_items = review.reviewer_action_items.as_json(only: %i[id description completed])
          user_action_items = review.user_action_items.as_json(only: %i[id description completed])

          updated_review = review.as_json(only: %i[title comments user_id reviewer_id])
          updated_review['reviewer_action_items_attributes'] = reviewer_action_items
          updated_review['user_action_items_attributes'] = user_action_items

          expected_review = update_params[:review].as_json
          expected_review['reviewer_id'] = admin.id
          expect(updated_review).to eq(expected_review)
        end

        it 'should delete action items' do
          put api_v1_admin_review_path(review), params: update_params_delete_ai, headers: auth_headers
          expect(response).to have_http_status 200

          review.reload
          reviewer_action_items = review.reviewer_action_items.as_json(only: %i[id description completed])
          expect(reviewer_action_items.length).to eq(1)

          expected_reviewer_action_items = update_params_delete_ai[:review]
                                           .as_json['reviewer_action_items_attributes'][0, 1]
          expect(reviewer_action_items).to eq(expected_reviewer_action_items)
        end

        it 'should show 404 if review does not exist' do
          highest_id = Review.last.id
          put api_v1_admin_review_path(highest_id + 1), params: update_params, headers: auth_headers
          expect(response).to have_http_status(404)
        end
      end

      context 'without authorization' do
        it 'should return unauthorized' do
          put api_v1_admin_review_path(review), headers: user_auth_headers
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'without authentication' do
      it 'should return unauthorized' do
        put api_v1_admin_review_path(review)
        expect(response).to have_http_status(401)
      end
    end
  end
end
