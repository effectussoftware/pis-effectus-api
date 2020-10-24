# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:review) { create(:review) }

  let!(:review_action_item_effectus) { create(:review_action_item_effectus, review_id: review.id) }

  let!(:review_action_item_user) { create(:review_action_item_user, review_id: review.id) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'GET /api/v1/admin/review/:id' do
    context 'with authorization' do
      it 'should get one review by id' do
        get api_v1_admin_review_path(review.id), headers: auth_headers
        expect(response).to have_http_status(200)
        response_body = Oj.load(response.body)
        response_expected = review.as_json(only: %i[id description title reviewer_id user_id])
        response_expected = response_expected.merge(
          'user_action_items' => [review_action_item_user.as_json(only: %i[id description completed])]
        ).merge(
          'reviewer_action_items' => [review_action_item_effectus.as_json(only: %i[id description completed])]
        )
        expect(response_body['review']).to eq(response_expected)
      end
      it 'should return error: no review with id highest_id + 1 ' do
        highest_id = Review.last.id
        get "/api/v1/admin/reviews/#{highest_id + 1}", headers: auth_headers
        expect(response).to have_http_status(404)
      end
    end

    context 'with no authorization' do
      it 'return unauthorized' do
        get "/api/v1/admin/reviews/#{review.id}"
        expect(response).to have_http_status(401)
      end
    end
  end
end
