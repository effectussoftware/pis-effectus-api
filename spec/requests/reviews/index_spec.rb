# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:reviews) { rand(1..10).times.map { create(:review_with_action_items) } }

  let!(:auth_headers) { admin.create_new_auth_token }

  def action_item_to_json(item)
    item.as_json(only: %i[id description completed])
  end

  def review_to_json(review)
    rev = review.as_json(only: %i[id comments title reviewer_id user_id])

    user_items = review.user_action_items.map { |x| action_item_to_json(x) }
    reviewer_items = review.reviewer_action_items.map { |x| action_item_to_json(x) }

    rev.merge(
      'reviewer_action_items' => reviewer_items,
      'user_action_items' => user_items
    )
  end

  describe 'GET /api/v1/admin/reviews' do
    context 'with authorization' do
      it 'should get all reviews' do
        get api_v1_admin_reviews_path, headers: auth_headers
        expect(response).to have_http_status(200)

        response_body = Oj.load(response.body)
        reviews_response = response_body['reviews'].map { |item| item.except('created_at') }

        response_expected = reviews.map { |review| review_to_json(review) }

        expect(reviews_response).to include(*response_expected)
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
