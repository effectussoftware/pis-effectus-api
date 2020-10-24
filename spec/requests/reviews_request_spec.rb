# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  # Cuando uso create estoy llamando a Factory BOT
  let!(:admin) { create(:admin) }
  let!(:review) { create(:review) }
  let!(:auth_headers) { admin.create_new_auth_token }
  let!(:headers) do
    {
      'uid' => auth_headers[:uid],
      'access-token' => auth_headers['access-token'],
      'client' => auth_headers[:client]
    }
  end
  let!(:update_review_params) do
    {
      'review' =>
        {
          'comments': 'nuevos comentarios de la 1o1',
          'user_action_items': [
            { 'completed': false, 'description': 'se compromete a usar menos el celular' }
          ],
          'reviewer_action_items': [
            { 'completed': false, 'description': 'se compromete a usar menos el celular' }
          ]
        }
    }
  end

  describe 'GET /api/v1/admin/reviews' do
    context 'with authorization' do
      it 'should get all reviews' do
        get api_v1_admin_reviews_path, headers: auth_headers
        expect(response).to have_http_status(200)
        response_body = Oj.load(response.body)
        expect(response_body['reviews'].size).to eq(Review.all.count)
      end
    end

    context 'with no authorization' do
      it 'should return unauthorized' do
        get api_v1_admin_reviews_path
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /api/v1/admin/reviews/:id' do
    context 'with authorization' do
      it 'should get review by id' do
        get "/api/v1/admin/reviews/#{review.id}", headers: auth_headers
        expect(response).to have_http_status(200)
        response_review = Oj.load(response.body)
        expect(response_review['review']['id']).to eq(review.id)
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

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'with authorization' do
      it 'updates review by id' do
        put "/api/v1/admin/reviews/#{review.id}", params: update_review_params, headers: auth_headers
        expect(response).to have_http_status(200)
        response_review = Oj.load(response.body)
        review.reload
        expect(response_review['review']['title']).to eq(review.title)
        expect(response_review['review']['comments']).to eq(review.comments)
        
        # compare action items
        debugger
        response_action_items = response_review['review']['user_action_items'].concat(response_review['review']['reviewer_action_items'])
        expect(response_action_items).to match_array(review.review_action_items)
      end
      
      it 'error: no review with id highest id + 1 ' do
        highest_id = Review.last.id
        put "/api/v1/admin/reviews/#{highest_id + 1}", params: update_review_params, headers: auth_headers
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
