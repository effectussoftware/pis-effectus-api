# frozen_string_literal: true

class Communication < ApplicationRecord
  validates :title, presence: true
  validate :cant_update_if_published
  validate :cant_update_if_recurrent
  after_save :send_notification, if: :just_published

  private

  def cant_update_if_published
    errors.add(:published, "can't update communications once published") if published_was
  end

  def cant_update_if_recurrent
    errors.add(:recurrent_on, "can't update communications if recurrent") if recurrent_on_was
  end

  def send_notification
    User.active.send_notification(title, text, { id: id, updated_at: updated_at, type: self.class.to_s })
  end

  def just_published
    saved_change_to_published? && published?
  end
end
