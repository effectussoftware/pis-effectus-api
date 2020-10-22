# frozen_string_literal: true

class Communication < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :title, presence: true

  has_one_attached :image

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
  validate :cant_update_if_published
  after_update :send_notification, if: :just_published

  private

  def cant_update_if_published
    errors.add(:published, "can't update communications once published") if was_already_published
  end

  def send_notification
    User.active.send_notification(title, text, { id: id, updated_at: updated_at, type: self.class.to_s })
  end

  def just_published
    saved_change_to_published? && published?
  end

  def was_already_published
    (!published_changed? && published?) || (published_changed? && !published?)
  end
end
