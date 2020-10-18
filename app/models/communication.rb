# frozen_string_literal: true

class Communication < ApplicationRecord
  include Rails.application.routes.url_helpers


  validates :title, presence: true
  has_one_attached :image

  def get_image_url
    url_for(self.image)
  end
end
