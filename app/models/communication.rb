# frozen_string_literal: true

class Communication < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  include Rails.application.routes.url_helpers

  validates :title, presence: true
  has_one_base64_attached :image

  validate :cant_update_if_published
  after_save :send_notification, if: :just_published

  scope :published, -> { where(published: true) }

  scope :not_dummy, -> { where(dummy: false) }

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
              "(extract(year from recurrent_on) < ?) OR
               to_char(recurrent_on, 'MMDDHHMISSMS') <= to_char(?::TIMESTAMP, 'MMDDHHMISSMS')"
            else
              "(extract(year from recurrent_on) < ?) OR
               to_char(recurrent_on, 'MMDDHHMISSMS') < to_char(?::TIMESTAMP, 'MMDDHHMISSMS')"
            end
    where(query, start_time.year, start_time)
  }

  def image_url
    url_for image
  end

  def create_recurrent_dummy
    return false if !recurrent_on

    new_communication = self.dup
    new_communication.image.attach(image.blob) if image.attached?
    new_communication.update(recurrent_on: nil, dummy: true)
  end

  private

  def cant_update_if_published
    errors.add(:published, "can't update communications once published") if published_was && !recurrent_on_was
  end

  def send_notification
    User.active.send_notification(title, text, { id: id, updated_at: updated_at, type: self.class.to_s })
  end

  def just_published
    saved_change_to_published? && published?
  end
end
