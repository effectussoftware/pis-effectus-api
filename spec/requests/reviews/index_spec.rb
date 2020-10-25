# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:review) { create(:review) }

  let!(:reviewer_action_item) { create(:reviewer_action_item, reviewer_review_id: review.id) }

  let!(:user_action_item) { create(:user_action_item, user_review_id: review.id) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'GET /api/v1/admin/reviews' do
    context 'with authorization' do
      it 'should get all reviews' do
        get api_v1_admin_reviews_path, headers: auth_headers
        expect(response).to have_http_status(200)
        response_body = Oj.load(response.body)
        response_expected = review.as_json(only: %i[id comments title reviewer_id user_id])
        response_expected = response_expected.merge(
          'user_action_items' => [user_action_item.as_json(only: %i[id description completed])]
        ).merge(
          'reviewer_action_items' => [reviewer_action_item.as_json(only: %i[id description completed])]
        )
        expect(response_body['reviews']).to include(response_expected)
      end
      
    end

    context 'with no authorization' do
      it 'should return unauthorized' do
        get api_v1_admin_reviews_path
        expect(response).to have_http_status(401)
      end
    end
  end
end
