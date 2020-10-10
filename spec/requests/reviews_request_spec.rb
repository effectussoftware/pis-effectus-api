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
  let!(:update_params) do
    {
      'review' =>
            {
              'output' => 'Segui asi!'
            }
    }
  end

  describe 'GET /api/v1/admin/reviews' do
    context 'return all reviews' do
      context 'with authorization' do
        it 'get all reviews' do
          get api_v1_admin_reviews_path, headers: auth_headers
          expect(response).to have_http_status(200)
          response_body = Oj.load(response.body)
          expect(response_body['reviews'].size).to eq(1)
        end
      end

      context 'with no authorization' do
        it 'return unauthorized' do
          get api_v1_admin_reviews_path
          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'GET /api/v1/admin/reviews/:id' do
    context 'return the review with id :id' do
      context 'with authorization' do
        it 'get review by id' do
          get "/api/v1/admin/reviews/#{review.id}", headers: auth_headers
          expect(response).to have_http_status(200)
          response_review = Oj.load(response.body)
          expect(response_review['review']['id']).to eq(review['id'])
        end
        it 'error: no review with id highest_id + 1 ' do
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

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'update the review with id :id' do
      context 'with authorization' do
        it 'update review by id' do
          put "/api/v1/admin/review/#{review.id}", params: update_params, headers: auth_headers
          expect(response).to have_http_status(200)
          response_review = Oj.load(response.body)
          expect(response_review['review']['id']).to eq(review['id'])
          review.reload
          expect(response_review['review']['output']).to eq('Segui asi!')
          expect(review.output).to eq('Segui asi!')
        end
        it 'error: no review with id highest id + 1 ' do
          highest_id = Review.last.id
          put "/api/v1/admin/reviews/#{highest_id + 1}", params: update_params.to_json, headers: auth_headers
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
end
