# frozen_string_literal: true

class Communication < ApplicationRecord
  include Rails.application.routes.url_helpers
  include ActiveStorageSupport::SupportForBase64

  validates :title, presence: true

  has_one_base64_attached :image

  def image_url
    url_for(image)
  end

  scope :not_recurrent_from_date, lambda { |start_time, with_include|
    query = if with_include
              'communications.updated_at <= ? AND
      communications.published = true AND
      communications.recurrent_on is NULL'
            else
              'communications.updated_at < ? AND
     communications.published = true AND
     communications.recurrent_on is NULL'
            end

    where(query, start_time)
  }
  scope :recurrent_from_date, lambda { |start_time, with_include|
    query = if with_include
              '(extract(month from recurrent_on) < ?) OR
       (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) <= ?)'
            else
              '(extract(month from recurrent_on) < ?) OR
       (extract(month from recurrent_on)= ? AND extract(day from recurrent_on) < ?)'
            end
    where(query, start_time.month, start_time.month, start_time.day)
  }
end
