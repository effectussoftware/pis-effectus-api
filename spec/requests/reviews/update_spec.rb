# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:review) { create(:review) }

  let!(:auth_headers) { admin.create_new_auth_token }

  describe 'PUT /api/v1/admin/reviews/:id' do
    context 'with authorization' do
      it 'should update review by id' do
        update_params = {
          'review': {
            'title': 'new_title',
            'comments': 'aaaa',
            'reviewer_action_items': [
              review.reviewer_action_items[0]
            ], 
            'user_action_items': [
              
            ]
          }
        }
        put "/api/v1/admin/reviews/#{review.id}", params: update_params, headers: auth_headers
        expect(response).to have_http_status(200)
        response_review = Oj.load(response.body)
        expect(response_review['review']['id' ]).to eq(review.id)
        review.reload

        response_expected = review.as_json(only: %i[id comments title reviewer_id user_id])
        response_expected = response_expected.merge(
          'user_action_items' => [user_action_item.as_json(only: %i[id description completed])]
        ).merge(
          'reviewer_action_items' => [reviewer_action_item.as_json(only: %i[id description completed])]
        )

        
        expect(response_body['reviews']).to include(response_expected)
        expect(response_review['review']['title']).to eq(update_params[:review][:title])
        expect(response_review['review']['comments']).to eq(update_params[:review][:comments])
        expect(response_review['review']['comments']).to eq(update_params[:review][:comments])
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
