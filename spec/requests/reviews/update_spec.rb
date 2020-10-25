# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:review) { create(:review) }

  let!(:reviewer_action_item) { create(:reviewer_action_item, reviewer_review_id: review.id) }

  let!(:user_action_item) { create(:user_action_item, user_review_id: review.id) }

  let(:update_params) do
    reviewer_action_item = review.reviewer_action_items.first.clone
    reviewer_action_item.description = 'updated reviewer description'
    updated_reviewer_action_items = [reviewer_action_item]
    {
      review: {
        title: 'new_title',
        comments: 'aaaa',
        reviewer_action_items: updated_reviewer_action_items
      }
    }
  end

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'with authorization' do
      it 'returns 404 if review does not exist' do
        highest_id = Review.last.id
        put "/api/v1/admin/reviews/#{highest_id + 1}", params: update_params, headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end

    context 'with no authorization' do
      it 'return unauthorized' do
        put "/api/v1/admin/reviews/#{review.id}"
        expect(response).to have_http_status(401)
      end
    end
  end
end
