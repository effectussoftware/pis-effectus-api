# frozen_string_literal: true

class Communication < ApplicationRecord
  include ActiveStorageSupport::SupportForBase64
  include Rails.application.routes.url_helpers

  validates :title, presence: true
  validates :text, presence: true
  has_one_base64_attached :image

  validate :cant_update_if_published
  after_save :send_notification, if: :just_published
  before_destroy :cant_destroy_if_published_not_recurrent

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
  scope :recurrent_from_date_hour, lambda { |requested_time|
    where("to_char(recurrent_on, 'MMDDHH') = to_char(?::TIMESTAMP, 'MMDDHH')", requested_time)
  }

  def image_url
    url_for image
  end

  def create_recurrent_dummy
    return false if !recurrent_on || !published

    new_communication = dup
    new_communication.image.attach(image.blob) if image.attached?
    new_communication.update(recurrent_on: nil, dummy: true)
  end

  private

  def cant_destroy_if_published_not_recurrent
    # rubocop:disable Metrics/LineLength
    throw ActiveRecord::RecordInvalid, "can't delete published non recurrent communications" if published_was && !recurrent_on_was
    # rubocop:enable Metrics/LineLength
  end

  def cant_update_if_published
    errors.add(:published, "can't update communications once published") if published_was
  end

  def send_notification
    User.active.send_notification(title, text, { id: id, updated_at: updated_at, type: self.class.to_s })
  end

  def just_published
    saved_change_to_published? && published?
  end
end
