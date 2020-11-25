# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:reviews) { create_list(:review_with_action_items, 17) }

  let!(:auth_headers) { admin.create_new_auth_token }

  def action_item_to_json(item)
    item.as_json(only: %i[id description completed])
  end

  def review_to_json(review)
    rev = review.as_json(only: %i[id comments title reviewer_id user_id updated_at])

    user_items = review.user_action_items.map { |x| action_item_to_json(x) }
    reviewer_items = review.reviewer_action_items.map { |x| action_item_to_json(x) }

    rev.merge(
      'reviewer_action_items' => reviewer_items,
      'user_action_items' => user_items
    )
  end

  describe 'GET /api/v1/admin/reviews' do
    context 'with authorization' do
      it 'should get first 10 reviews' do
        per_page = 10
        get api_v1_admin_reviews_path(per_page: per_page), headers: auth_headers
        expect(response).to have_http_status(200)

        response_body = Oj.load(response.body)
        reviews_response = response_body['reviews'].map { |item| item.except('created_at') }

        expect(reviews_response.length).to eq per_page

        response_expected = Review.order(id: :desc).limit(per_page).map { |review| review_to_json(review) }
        expect(reviews_response).to eq(response_expected)
      end

      it 'should get page 2 reviews' do
        per_page = 2
        page = 2
        get api_v1_admin_reviews_path(per_page: per_page, page: page), headers: auth_headers
        expect(response).to have_http_status(200)

        response_body = Oj.load(response.body)
        reviews_response = response_body['reviews'].map { |item| item.except('created_at') }

        expect(reviews_response.length).to eq per_page
        response_expected = Review.order(id: :desc).offset((page - 1) * per_page).limit(per_page)
                                  .map { |review| review_to_json(review) }
        expect(reviews_response).to eq(response_expected)
      end

      it 'should return reviews sorted descending by title' do
        per_page = 5
        get api_v1_admin_reviews_path(per_page: per_page, 'sort': %w[title DESC].to_s), headers: auth_headers
        expect(response).to have_http_status(200)

        response_body = Oj.load(response.body)
        reviews_response = response_body['reviews'].map { |item| item.except('created_at') }

        response_expected = Review.order(title: :desc).limit(per_page).map { |review| review_to_json(review) }
        expect(reviews_response).to eq(response_expected)
      end

      it 'should return reviews filtered by user_id' do
        per_page = 7
        user = create(:user)
        create(:review_with_action_items, user: user)
        get api_v1_admin_reviews_path(per_page: per_page, user_id: user.id), headers: auth_headers
        expect(response).to have_http_status(200)

        response_body = Oj.load(response.body)
        reviews_response = response_body['reviews'].map { |item| item.except('created_at') }

        response_expected = Review.where(user_id: user.id).order(id: :desc).limit(per_page)
                                  .map { |review| review_to_json(review) }
        expect(reviews_response).to eq(response_expected)
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
