# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:review) { create(:review) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'with authorization' do
      it 'update review by id' do
        put "/api/v1/admin/reviews/#{review.id}", params: update_params, headers: auth_headers
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
