# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post endpoint', type: :request do
  let!(:admin) { create(:admin) }

  let!(:user) { create(:user) }

  let!(:review) { create(:review) }

  let!(:auth_headers) { admin.create_new_auth_token }

  let!(:user_auth_headers) { user.create_new_auth_token }

  describe do
    context 'with authentication' do
      context 'with authorization' do
        it 'should delete review' do
          delete api_v1_admin_review_path(review), headers: auth_headers
          expect(response).to have_http_status 200
        end

        it 'should not delete if missing' do
          highest_id = Review.last.id
          delete api_v1_admin_review_path(highest_id + 1), headers: auth_headers
          expect(response).to have_http_status 403
        end
      end

      context 'with no authorization' do
        it 'should return 401' do
          delete api_v1_admin_review_path(review), headers: user_auth_headers
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'with no authentication' do
      it 'should return 401' do
        delete api_v1_admin_reviews_path
        expect(response).to have_http_status(401)
      end
    end
  end


end
