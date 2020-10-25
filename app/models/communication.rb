# frozen_string_literal: true

class Communication < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  include Rails.application.routes.url_helpers

  validates :title, presence: true
  has_one_base64_attached :image

  def image_url
    url_for image
  end
end
